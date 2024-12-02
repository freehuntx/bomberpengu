using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace Json
{
  class Serializer
  {
    public static object Parse(string json)
    {
      var parser = new Parser(json);
      return parser.ParseValue();
    }

    public static string Stringify(object value)
    {
      if (value == null) return "null";
      if (value is string)
        return string.Format("\"{0}\"", ((string)value).Replace("\"", "\\\""));
      if (value is bool)
        return (bool)value ? "true" : "false";
      if (value is int || value is double || value is float)
        return value.ToString();

      var dict = value as Dictionary<string, object>;
      if (dict != null)
      {
        var pairs = new List<string>();
        foreach (var kvp in dict)
          pairs.Add(string.Format("\"{0}\":{1}", kvp.Key, Stringify(kvp.Value)));
        return "{" + string.Join(",", pairs) + "}";
      }

      var list = value as IList<object>;
      if (list != null)
        return "[" + string.Join(",", list.Select(item => Stringify(item))) + "]";

      throw new Exception(string.Format("Unsupported type: {0}", value.GetType()));
    }
  }

  class Parser
  {
    private readonly string json;
    private int pos;

    public Parser(string json)
    {
      this.json = json;
    }

    public object ParseValue()
    {
      SkipWhitespace();
      if (pos >= json.Length) throw new Exception("Unexpected end");

      char c = json[pos];
      if (c == '{') return ParseObject();
      if (c == '[') return ParseArray();
      if (c == '"') return ParseString();
      if (c == 't') return ParseKeyword("true", true);
      if (c == 'f') return ParseKeyword("false", false);
      if (c == 'n') return ParseKeyword("null", null);
      if (char.IsDigit(c) || c == '-') return ParseNumber();

      throw new Exception(string.Format("Unexpected character: {0}", json[pos]));
    }

    private Dictionary<string, object> ParseObject()
    {
      var result = new Dictionary<string, object>();
      pos++; // Skip {

      while (pos < json.Length)
      {
        SkipWhitespace();
        if (json[pos] == '}') { pos++; break; }
        if (result.Count > 0)
        {
          if (json[pos] != ',') throw new Exception("Expected ,");
          pos++;
          SkipWhitespace();
        }

        var key = ParseString();
        SkipWhitespace();
        if (pos >= json.Length || json[pos++] != ':')
          throw new Exception("Expected :");
        result[key] = ParseValue();
      }

      return result;
    }

    private List<object> ParseArray()
    {
      var result = new List<object>();
      pos++; // Skip [

      while (pos < json.Length)
      {
        SkipWhitespace();
        if (json[pos] == ']') { pos++; break; }
        if (result.Count > 0)
        {
          if (json[pos] != ',') throw new Exception("Expected ,");
          pos++;
        }
        result.Add(ParseValue());
      }

      return result;
    }

    private string ParseString()
    {
      if (json[pos++] != '"') throw new Exception("Expected \"");
      var sb = new StringBuilder();

      while (pos < json.Length)
      {
        var c = json[pos++];
        if (c == '"') return sb.ToString();
        if (c == '\\')
        {
          if (pos >= json.Length) throw new Exception("Unterminated string");
          c = json[pos++];
          switch (c)
          {
            case 'n': sb.Append('\n'); break;
            case 'r': sb.Append('\r'); break;
            case 't': sb.Append('\t'); break;
            case 'b': sb.Append('\b'); break;
            case 'f': sb.Append('\f'); break;
            case '\\': sb.Append('\\'); break;
            case '/': sb.Append('/'); break;
            case '"': sb.Append('"'); break;
            case 'u':
              if (pos + 4 > json.Length) throw new Exception("Invalid unicode escape sequence");
              var hex = json.Substring(pos, 4);
              pos += 4;
              sb.Append((char)Convert.ToInt32(hex, 16));
              break;
            default:
              throw new Exception(string.Format("Invalid escape sequence: \\{0}", c));
          }
        } else
        {
          sb.Append(c);
        }
      }

      throw new Exception("Unterminated string");
    }

    private double ParseNumber()
    {
      var start = pos;
      while (pos < json.Length && "0123456789+-.eE".Contains(json[pos])) pos++;
      return double.Parse(json.Substring(start, pos - start));
    }

    private object ParseKeyword(string keyword, object value)
    {
      if (pos + keyword.Length > json.Length ||
          json.Substring(pos, keyword.Length) != keyword)
        throw new Exception(string.Format("Expected {0}", keyword));
      pos += keyword.Length;
      return value;
    }

    private void SkipWhitespace()
    {
      while (pos < json.Length && char.IsWhiteSpace(json[pos])) pos++;
    }
  }
}
