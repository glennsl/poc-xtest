open IJAssert

type t

external expect : 'a -> < .. > Js.t = "" [@@bs.val]
external arrayContaining : 'a array -> 'b = "expect.arrayContaining" [@@bs.val]
external stringContaining : string -> 'b = "expect.stringContaining" [@@bs.val]

let _assert : IJAssert.t -> unit = function
| CloseTo (a, b, digits) -> (expect a) ## toBeCloseTo b digits
| Equals (a, b, _) -> (expect a) ## toEqual b
| False a -> (expect a) ## toBeFalsy ()
| GreaterThan (a, b) -> (expect a) ## toBeGreaterThan b
| LessThan (a, b) -> (expect a) ## toBeLessThan b
| ListContains (l, x, _) -> (expect @@ Array.of_list l) ## toContain x
| ListContainsAll (l, l', _) -> (expect @@ Array.of_list l) ## toEqual (arrayContaining @@ Array.of_list l')
| Raises f -> (expect f) ## toThrow ()
| StringContains (s, s') -> (expect s) ## toEqual (stringContaining s')
| True a -> (expect a) ## toBeTruthy ()

external describe : string -> (unit -> t list) -> t = "" [@@bs.val]

external test : string -> (unit -> unit Js.undefined) -> t = "" [@@bs.val]
let test label f =
  test label (fun () ->
    f () |> _assert;
    Js.undefined)

let run _ =
  () (* noop *)

module Skip = struct
  external describe : string -> (unit -> t list) -> t = "describe.skip" [@@bs.val]
  external test : string -> (unit -> IJAssert.t) -> t = "test.skip" [@@bs.val]
end