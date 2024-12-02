export function promisify(fnc: (...args: any) => void) {
  return (...args: any[]) => new Promise((resolve, reject) => {
    fnc(...args, resolve, reject)
  })
}