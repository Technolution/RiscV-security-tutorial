/******************************************************************************

 (C) COPYRIGHT 2016 TECHNOLUTION B.V., GOUDA NL
| =======          I                   ==          I    =
|    I             I                    I          I
|    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
|    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
|    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
|    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
|    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
|                 +---------------------------------------------------+
+----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
     |            |             ++++++++++++++++++++++++++++++++++++++|
     +------------+                          +++++++++++++++++++++++++|
                                                        ++++++++++++++|
                                                                 +++++|

 -----------------------------------------------------------------------------
  Title      :  exploit linker file
  Author     :  Jonathan Hofman
 -----------------------------------------------------------------------------

  Description:  This linker file is used to link the exploit code. It 
                therefore does not define and initialize all section types


******************************************************************************/

OUTPUT_ARCH( "riscv" )

//_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 0x10000;
//_HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 0x10000;

/*****************************************************************************
 * Define memory layout
 ****************************************************************************/
MEMORY {
	mem : ORIGIN = 0x8000d290, LENGTH = 0x0001000
}

/* Specify the default entry point to the program */

ENTRY(payload)

/*****************************************************************************
 * Define the sections, and where they are mapped in memory 
 ****************************************************************************/
SECTIONS {
	.text : {
	   __exploit_start = .;
		*(.text);
		*(.text.*);
	} > mem

	.init : {
	   KEEP (*(.init))
	} > mem

    .fini : {
       KEEP (*(.fini))
    } > mem

    .rodata : {
        . = ALIGN(4);
       __rodata_start = .;
       *(.rodata)
       *(.rodata.*)
       *(.gnu.linkonce.r.*)
       __rodata_end = .;
	} > mem

	.sbss : {
	   __sbss_start = .;
	   *(.sbss)
	   *(.sbss.*)
	   *(.gnu.linkonce.sb.*)
	   __sbss_end = .;
	} > mem
	
    .sdata : {
        . = ALIGN(4);
        _gp = . + 0x800;
        *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
        *(.sdata .sdata.* .gnu.linkonce.s.*)
     }	> mem

	.sbss2 : {
	   __sbss2_start = .;
	   *(.sbss2)
	   *(.sbss2.*)
	   *(.gnu.linkonce.sb2.*)
	   __sbss2_end = .;
	} > mem

	.data : {
	   . = ALIGN(8);
	   __data_start = .;
	   *(.data)
	   *(.data.*)
	   *(.gnu.linkonce.d.*)
	   __data_end = .;
	} > mem

    .bss : {
       . = ALIGN(8);
       __bss_start = .;
       *(.bss)
       *(.bss.*)
       *(.gnu.linkonce.b.*)
       *(COMMON)
       . = ALIGN(4);
       __bss_end = .;
    } > mem
      
    __exploit_end = .;
}
INCLUDE "build/exploit.ld";
