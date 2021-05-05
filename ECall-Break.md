2.8 Environment Call and Breakpoints
SYSTEM instructions are used to access system functionality that might require privileged access
and are encoded using the I-type instruction format. These can be divided into two main
classes: those that atomically read-modify-write control and status registers (CSRs), and all other
potentially privileged instructions. CSR instructions are described in Chapter 10, and the base
unprivileged instructions are described in the following section.

    fn12      rs1  fn3  rd    icode
000000000000 00000 000 00000 1110011 ECALL
000000000001 00000 000 00000 1110011 EBREAK
