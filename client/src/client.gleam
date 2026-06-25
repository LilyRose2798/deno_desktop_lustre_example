import gleam/int
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import shared

pub fn main() -> Nil {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#" <> shared.app_element_id, Nil)
  Nil
}

type Model {
  Model(count: Int)
}

type Message {
  Increment
}

fn init(_args: Nil) -> #(Model, Effect(Message)) {
  #(Model(count: 0), effect.none())
}

fn update(model: Model, message: Message) -> #(Model, Effect(Message)) {
  let Model(count:) = model
  case message {
    Increment -> {
      let count = count + 1
      #(Model(count:), effect.none())
    }
  }
}

fn view(model: Model) -> Element(Message) {
  let Model(count:) = model
  html.div(
    [
      attribute.styles([
        #("display", "flex"),
        #("flex-direction", "column"),
        #("align-items", "center"),
        #("justify-content", "center"),
      ]),
    ],
    [
      html.h1([], [
        html.text("Deno Desktop Lustre Example"),
      ]),
      html.p([], [
        html.text("Hello from Lustre client app!"),
      ]),
      html.p([], [html.text("Counter: " <> int.to_string(count))]),
      html.button(
        [
          attribute.styles([
            #("padding", "1em 1.3em"),
            #("color", "#fff"),
            #("background-color", "#8b50bf"),
            #("border", "0"),
            #("border-radius", "0.5em"),
          ]),
          event.on_click(Increment),
        ],
        [html.text("+")],
      ),
    ],
  )
}
