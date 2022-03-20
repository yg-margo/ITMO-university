module ternary_min(a0, a1, b0, b1, out0, out1);
  input a0, a1, b0, b1;
  output out0, out1;
  
  wire w00, w01, w10, w;
  
  binary_and a0_and_b0(a0, b0, w00);
  binary_and a0_and_b1(a0, b1, w01);
  binary_and a1_and_b0(a1, b0, w10);
  binary_or or1_res(w00, w01, w);
  binary_or out0_res(w10, w, out0);
  
  binary_and out1_res(a1, b1, out1);
endmodule

module ternary_max(a0, a1, b0, b1, out0, out1);
  input a0, a1, b0, b1;
  output out0, out1;

endmodule

module ternary_any(a0, a1, b0, b1, out0, out1);
  input a0, a1, b0, b1;
  output out0, out1;

endmodule

module ternary_consensus(a0, a1, b0, b1, out0, out1);
  input a0, a1, b0, b1;
  output out0, out1;
  
  wire w_or_a, w_or_b, w_or, w_and;
  
  binary_or a0_or_a1(a0, a1, w_or_a);
  binary_or b0_or_b1(b0, b1, w_or_b);
  binary_or or_res(w_or_a, w_or_b, w_or);
  binary_and and_res(a1, b1, w_and);
  binary_xor out0_res(w_or, w_and, out0);
  
  binary_and out1_res(a1, b1, out1);
endmodule

module binary_not(a, out);
  input a;
  output out;
  
  supply1 power;
  supply0 ground;
  
  pmos p(out, power, a);
  nmos n(out, ground, a);
endmodule

module binary_nand(a, b, out);
  input a, b;
  output out;
  
  supply1 power;
  supply0 ground;
  
  wire w;
  
  pmos p1(out, power, a);
  pmos p2(out, power, b);
  nmos n1(w, ground, a);
  nmos n2(out, w, b);
endmodule

module binary_and(a, b, out);
  input a, b;
  output out;
  
  wire w;
  
  binary_nand nand_res(a, b, w);
  binary_not not_res(w, out);
endmodule

module binary_nor(a, b, out);
  input a, b;
  output out;
  
  supply1 power;
  supply0 ground;
  
  wire w;
  
  pmos p1(w, power, a);
  pmos p2(out, w, b);
  nmos n1(out, ground, a);
  nmos n2(out, ground, b);
endmodule

module binary_or(a, b, out);
  input a, b;
  output out;
  
  wire w;
  
  binary_nor nor_res(a, b, w);
  binary_not not_res(w, out);
endmodule

module binary_xor(a, b, out);
  input a, b;
  output out;
  
  wire w_nand, w_or;
  
  binary_nand nand_res(a, b, w_nand);
  binary_or or_res(a, b, w_or);
  binary_and out_res(w_nand, w_or, out);
endmodule