// read the value set in serve.js as it's in the root of the project
// falls back to looking for a public dir in the current directory if not set
export const getPublicDir = () => globalThis.__public_dir ?? "public"
