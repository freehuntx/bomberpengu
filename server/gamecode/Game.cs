using System;
using System.Collections.Generic;
using PlayerIO.GameLibrary;
using System.Linq;
using System.Xml;

namespace BomberPenguGame
{

  public class Match
  {
    readonly Room room;
    public List<Player> players = new List<Player>();

    public Match(Room room, Player playerA, Player playerB)
    {
      this.room = room;
      players.Add(playerA);
      players.Add(playerB);
    }

    public void Start()
    {
      foreach (var player in players)
      {
        player.Spawn();
      }
    }
  }

	public class Player : BasePlayer
  {
    public List<Player> challengedPlayers = new List<Player>();
    public Match match;

    public string Name;
    public bool alive = false;
		public bool challengeAll = false;
    int wins = 0;
    int loses = 0;
    int draws = 0;

    public string Skill
    {
      get { return $"{wins}/{loses}/{draws}"; }
    }

    public bool InMatch
    {
      get { return match != null; }
    }

    public void Win()
    {
      wins++;
    }

    public void Draw()
    {
      draws++;
    }

    public void Die()
    {
      if (!InMatch || !alive) return;
      alive = false;
      loses++;
    }

    public void Spawn()
    {
      alive = true;
    }

    public string GetState(Player askingPlayer)
    {
      if (askingPlayer == this) return "5";

      var state = InMatch ? "3" : "";

      if (challengeAll) state = "1" + state;
      else if (askingPlayer.challengeAll) state = "2" + state;
      else if (state == "") state = "0";

      return state;
    }

    public void Disconnect(string reason)
    {
      Send("xml", $"<errorMsg>{reason}</errorMsg>");
      Disconnect();
    }
  }

	[RoomType("Lobby")]
	public class Room : Game<Player> {

    public override bool AllowUserJoin(Player player)
    {
      var hasName = player.JoinData.TryGetValue("name", out string name);
      if (!hasName || name == "")
      {
        player.Disconnect("Missing name!");
        return false;
      }

      if (Players.Count(p => p.Name == name) > 0)
      {
        player.Disconnect("Name taken!");
        return false;
      }

      player.Name = name;

      return true;
    }

    public override void UserJoined(Player player)
    {
      var userListXml = "<userList>";

      foreach (var p in Players)
      {
        // If its another player, inform him about us
        if (p != player)
        {
          p.Send("xml", $"<newPlayer name=\"{player.Name}\" skill=\"{player.Skill}\" state=\"{player.GetState(p)}\" />");
        }

        userListXml += $"<user name=\"{p.Name}\" skill=\"{p.Skill}\" state=\"{p.GetState(player)}\" />";
      }

      userListXml += "</userList>";
      player.Send("xml", userListXml);
    }

		public override void UserLeft(Player player)
    {
      foreach(var p in Players)
      {
        if (p == player) continue;

        p.challengedPlayers.Remove(player);
      }

      Broadcast("xml", $"<playerLeft name=\"{player.Name}\" />");
    }

		private void OnXml(Player player, XmlDocument xml, string xmlString)
    {
			string rootName = xml.DocumentElement.Name;

			if (rootName == "auth")
			{
        var name = xml.DocumentElement.Attributes["name"]?.Value ?? "";
        if (name != player.Name)
        {
          player.Disconnect("Name mismatch!");
          return;
        }

        return;
      }

      if (rootName == "toRoom")
      {
        if (!player.InMatch) return;

        player.match.players.Remove(player);
        player.match = null;

        foreach (var p in Players)
        {
          if (p == player) continue;
          p.Send("xml", $"<playerUpdate name=\"{player.Name}\" skill=\"{player.Skill}\" state=\"{player.GetState(p)}\" />");
        }

        return;
      }

			if (rootName == "challenge")
			{
				var targetPlayerName = xml.DocumentElement.Attributes["name"]?.Value ?? "";
        if (targetPlayerName == "")  return;

        var targetPlayer = Players.Where(p => p.Name == targetPlayerName).FirstOrDefault();
				if (targetPlayer == null) return;

        player.challengedPlayers.Add(targetPlayer);

        targetPlayer.Send("xml", $"<request name=\"{player.Name}\" />\0");
				return;
      }

			if (rootName == "remChallenge")
      {
        var targetPlayerName = xml.DocumentElement.Attributes["name"]?.Value ?? "";
        if (targetPlayerName == "") return;

        var targetPlayer = player.challengedPlayers.Where(p => p.Name == targetPlayerName).FirstOrDefault();
        if (targetPlayer == null) return;

				player.challengedPlayers.Remove(targetPlayer);

        targetPlayer.Send("xml", $"<remRequest name=\"{player.Name}\" />\0");
        return;
      }

      if (rootName == "challengeAll")
      {
        if (player.challengeAll) return;

        player.challengeAll = true;

				foreach (var p in Players)
				{
					if (p == player) continue;
					if (player.challengedPlayers.Contains(p)) continue;

					player.challengedPlayers.Add(p);
					p.Send("xml", $"<request name=\"{player.Name}\" />\0");
				}

        return;
      }

      if (rootName == "remChallengeAll")
      {
        if (!player.challengeAll) return;
        player.challengeAll = false;

        foreach (var p in player.challengedPlayers)
        {
          p.Send("xml", $"<remRequest name=\"{player.Name}\" />\0");
        }

        player.challengedPlayers.Clear();

        return;
      }

			if (rootName == "startGame")
      {
        var targetPlayerName = xml.DocumentElement.Attributes["name"]?.Value ?? "";
        if (targetPlayerName == "") return;

        var targetPlayer = Players.Where(p => p.Name == targetPlayerName).FirstOrDefault();
        if (targetPlayer == null) return;
        if (player.match != targetPlayer.match) return;

        // If there is no match yet, create it
        if (player.match == null)
        {
          player.match = new Match(this, player, targetPlayer);
          targetPlayer.match = player.match;
        }

        player.challengeAll = false;
        targetPlayer.challengeAll = false;

        targetPlayer.Send("xml", $"<startGame name=\"{player.Name}\" />");

        player.match.Start();

        return;
      }

			if (rootName == "winGame")
			{
        if (!player.InMatch) return;
        player.Win();
				return;
      }

      if (rootName == "drawGame")
      {
        if (!player.InMatch) return;
        player.Draw();
        return;
      }

      if (rootName == "die")
      {
        if (!player.InMatch) return;
        if (!player.alive) return;
        player.Die();

        var enemy = player.match.players.FirstOrDefault(p => p != player);

        if (enemy != null && !enemy.alive)
        {
          player.Draw();
          enemy.Draw();

          player.Send("xml", $"<draw />");
          enemy.Send("xml", $"<draw />");
        }
      }

      if (rootName == "msgPlayer")
      {
        var msg = xml.DocumentElement.Attributes["msg"]?.Value ?? "";
        if (player.match == null) return;

        var enemy = player.match.players.FirstOrDefault(p => p != player);
        if (enemy == null) return;

        enemy.Send("xml", $"<msgPlayer name=\"{player.Name}\" msg=\"{msg}\" />");

        return;
      }

      if (rootName == "msgAll")
      {
        var msg = xml.DocumentElement.Attributes["msg"]?.Value ?? "";
        if (player.InMatch || msg == "") return;

				foreach (var p in Players)
				{
					if (p == player || p.InMatch) continue;
					p.Send("xml", $"<msgAll name=\"{player.Name}\" msg=\"{msg}\" />");
				}

        return;
      }

      if (rootName == "surrender")
      {
        if (!player.InMatch) return;
        var enemy = player.match.players.FirstOrDefault(p => p != player);

        player.Die();

        player.Send("xml", $"<surrender winner=\"{enemy.Name}\" />");
        enemy?.Send("xml", $"<surrender winner=\"{enemy.Name}\" />");

        return;
			}

      // These should be sent to the enemy
			if (
        rootName == "die" ||
        rootName == "playAgain" ||
        rootName == "Tag10" ||
        rootName == "Tag11" || 
				rootName == "Tag12" || 
				rootName == "Tag14" || 
				rootName == "Tag16" || 
				rootName == "Tag17" || 
				rootName == "Tag18" || 
				rootName == "Tag19"
			)
			{
				if (!player.InMatch) return;
        
        foreach (var p in player.match.players)
        {
          if (p == player) continue;
          p.Send("xml", xmlString);
        }
        return;
			}

			if (rootName == "ping")
			{
				player.Send("xml", "<pong/>");
				return;
			}

      Console.WriteLine($"Unhandled: {xmlString}");
    }

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message)
    {
			if (message.Type == "xml")
      {
				string xmlString = message.GetString(0);
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(xmlString);
        OnXml(player, xmlDoc, xmlString);
        return;
			}

			Console.WriteLine("[Error] Unhandled message type: " + message.Type);
		}
	}
}
