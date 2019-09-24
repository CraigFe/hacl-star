module Spec.Box.Test

open FStar.Mul
open Lib.IntTypes
open Lib.RawIntTypes
open Lib.Sequence
open Lib.ByteSequence
open Spec.Box


#set-options "--lax"


let plain = List.Tot.map u8_from_UInt8 [
  0x00uy;  0x01uy;  0x02uy;  0x03uy;   0x04uy;  0x05uy;  0x06uy;  0x07uy;
  0x08uy;  0x09uy;  0x10uy;  0x11uy;   0x12uy;  0x13uy;  0x14uy;  0x15uy;
  0x16uy;  0x17uy;  0x18uy;  0x19uy;   0x20uy;  0x21uy;  0x22uy;  0x23uy;
  0x00uy;  0x01uy;  0x02uy;  0x03uy;   0x04uy;  0x05uy;  0x06uy;  0x07uy;
  0x08uy;  0x09uy;  0x10uy;  0x11uy;   0x12uy;  0x13uy;  0x14uy;  0x15uy;
  0x16uy;  0x17uy;  0x18uy;  0x19uy;   0x20uy;  0x21uy;  0x22uy;  0x23uy;
  0x00uy;  0x01uy;  0x02uy;  0x03uy;   0x04uy;  0x05uy;  0x06uy;  0x07uy;
  0x08uy;  0x09uy;  0x10uy;  0x11uy;   0x12uy;  0x13uy;  0x14uy;  0x15uy;
  0x16uy;  0x17uy;  0x18uy;  0x19uy;   0x20uy;  0x21uy;  0x22uy;  0x23uy
 ]

let nonce = List.Tot.map u8_from_UInt8 [
  0x00uy; 0x01uy; 0x02uy; 0x03uy;
  0x04uy; 0x05uy; 0x06uy; 0x07uy;
  0x08uy; 0x09uy; 0x10uy; 0x11uy;
  0x12uy; 0x13uy; 0x14uy; 0x15uy;
  0x16uy; 0x17uy; 0x18uy; 0x19uy;
  0x20uy; 0x21uy; 0x22uy; 0x23uy
]

let key = List.Tot.map u8_from_UInt8 [
  0x85uy; 0xd6uy; 0xbeuy; 0x78uy;
  0x57uy; 0x55uy; 0x6duy; 0x33uy;
  0x7fuy; 0x44uy; 0x52uy; 0xfeuy;
  0x42uy; 0xd5uy; 0x06uy; 0xa8uy;
  0x01uy; 0x03uy; 0x80uy; 0x8auy;
  0xfbuy; 0x0duy; 0xb2uy; 0xfduy;
  0x4auy; 0xbfuy; 0xf6uy; 0xafuy;
  0x41uy; 0x49uy; 0xf5uy; 0x1buy
]

let sk1 = List.Tot.map u8_from_UInt8 [
  0x85uy; 0xd6uy; 0xbeuy; 0x78uy;
  0x57uy; 0x55uy; 0x6duy; 0x33uy;
  0x7fuy; 0x44uy; 0x52uy; 0xfeuy;
  0x42uy; 0xd5uy; 0x06uy; 0xa8uy;
  0x01uy; 0x03uy; 0x80uy; 0x8auy;
  0xfbuy; 0x0duy; 0xb2uy; 0xfduy;
  0x4auy; 0xbfuy; 0xf6uy; 0xafuy;
  0x41uy; 0x49uy; 0xf5uy; 0x1buy
]

let sk2 = List.Tot.map u8_from_UInt8 [
  0x85uy; 0xd6uy; 0xbeuy; 0x78uy;
  0x57uy; 0x55uy; 0x6duy; 0x33uy;
  0x7fuy; 0x44uy; 0x52uy; 0xfeuy;
  0x42uy; 0xd5uy; 0x06uy; 0xa8uy;
  0x01uy; 0x03uy; 0x80uy; 0x8auy;
  0xfbuy; 0x0duy; 0xb2uy; 0xfduy;
  0x4auy; 0xbfuy; 0xf6uy; 0xafuy;
  0x41uy; 0x49uy; 0xf5uy; 0x1cuy]


#set-options "--max_fuel 0 --z3rlimit 25"

let test () =
  assert_norm(List.Tot.length sk1 = 32);
  assert_norm(List.Tot.length sk2 = 32);
  assert_norm(List.Tot.length nonce = 24);
  assert_norm(List.Tot.length plain = 72);

  let sk1 = of_list sk1 in
  let sk2 = of_list sk2 in
  let nonce = of_list nonce in
  let plaintext = of_list plain in

  let pk1 = Spec.Curve25519.secret_to_public sk1 in
  let pk2 = Spec.Curve25519.secret_to_public sk2 in

  let mac_cipher = box_detached sk1 pk2 nonce plaintext in
  let (mac, cipher) = match mac_cipher with | Some p -> p | None -> (create 16 (u8 0), create 72 (u8 0)) in

  let dec = box_open_detached pk1 sk2 nonce mac cipher in
  let dec_p = match dec with | Some p -> p | None -> create 72 (u8 0) in
  let result_decryption = for_all2 (fun a b -> uint_to_nat #U8 a = uint_to_nat #U8 b) dec_p plaintext in

  if result_decryption then IO.print_string "\nSuccess!\n"
  else IO.print_string "\nFailure :("