import filepath
import gleam/http.{type Method}
import gleam/http/request
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/option
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import shared
import smol.{type Request, type Response}

fn error_page(message: String) -> Element(a) {
  html.html([], [
    html.p([], [
      html.text(message),
    ]),
  ])
}

fn not_found_response(path: String) -> Promise(Response) {
  error_page("Page not found at path " <> path)
  |> element.to_document_string
  |> smol.send_html
  |> smol.with_status(404)
}

fn method_not_allowed_response(
  method: Method,
  path: String,
) -> Promise(Response) {
  error_page(
    "Method "
    <> http.method_to_string(method)
    <> " not allowed for path "
    <> path,
  )
  |> element.to_document_string
  |> smol.send_html
  |> smol.with_status(405)
}

fn index_response() -> Promise(Response) {
  html.html([], [
    html.head([], [
      html.link([
        attribute.rel("stylesheet"),
        attribute.href("/public/style.css"),
      ]),
      html.script(
        [attribute.type_("module"), attribute.src("/public/client.js")],
        "",
      ),
    ]),
    html.body([], [
      html.div([attribute.id(shared.app_element_id)], [
        html.noscript([], [
          html.p([], [html.text("JavaScript is required for this page.")]),
        ]),
      ]),
    ]),
  ])
  |> element.to_document_string
  |> smol.send_html
}

@external(javascript, "./server.ffi.mjs", "getPublicDir")
fn get_public_dir() -> String

fn public_file_response(path: String) -> Promise(Response) {
  case filepath.expand(path) {
    Ok("/public/" <> path) ->
      smol.send_file(
        filepath.join(get_public_dir(), path),
        0,
        option.None,
        fn(error) {
          case error {
            smol.NoEntry ->
              smol.send_string("File not found")
              |> smol.with_status(404)
            _ ->
              smol.send_string("Unable to read file") |> smol.with_status(500)
          }
        },
      )
    Ok(_) -> smol.send_string("Invalid file path") |> smol.with_status(400)
    Error(_) ->
      smol.send_string("File path traversed outside the public directory")
      |> smol.with_status(400)
  }
}

pub fn handler(req: Request) -> Promise(Response) {
  io.println_error(http.method_to_string(req.method) <> " " <> req.path)
  case req.method, request.path_segments(req) {
    http.Get, [] -> index_response()
    _, [] -> method_not_allowed_response(req.method, req.path)
    http.Get, ["public", ..] -> public_file_response(req.path)
    _, _ -> not_found_response(req.path)
  }
}
