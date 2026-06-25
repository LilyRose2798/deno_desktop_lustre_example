import { handler } from "./build/dev/javascript/server/server.mjs"
import { adapt } from "./build/dev/javascript/smol/adapt.ffi.mjs"

export default {
  fetch: adapt(handler)
}
