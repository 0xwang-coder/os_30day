/* https://vanya.jp.net/os/haribote.html#hrb */
OUTPUT_FORMAT("binary");
OUTPUT_ARCH(i386)

SECTIONS
{

    .text : { *(.text) }

    .data 0x310000 : AT ( ADDR(.text) + SIZEOF(.text) ) {
        *(.data)
        *(.rodata*)
        *(.bss)
    }

    /DISCARD/ : { *(.eh_frame) }
    /DISCARD/ : { *(.note.gnu.property)}
}