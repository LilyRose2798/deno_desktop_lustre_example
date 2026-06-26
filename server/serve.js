import { handler } from "./build/dev/javascript/server/server.mjs"
import { adapt } from "./build/dev/javascript/smol/adapt.ffi.mjs"

globalThis.__public_dir =
  import.meta.dirname === undefined ?
    undefined
  : (globalThis.process.platform === "win32" ?
      import.meta.dirname.replace(/\\/g, "/")
    : import.meta.dirname) + "/public"

export default {
  fetch: adapt(handler),
}
