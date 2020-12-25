/* https://vanya.jp.net/os/haribote.html#hrb */
OUTPUT_FORMAT("binary");
OUTPUT_ARCH(i386)

SECTIONS
{
    .head 0x0 : {
        LONG(64 * 1024)      
        LONG(0x69726148)     
        LONG(0)              
        LONG(0x310000)       
        LONG(SIZEOF(.data))  
        LONG(LOADADDR(.data))
        LONG(0xE9000000)
        LONG(HariMain - 0x20)
        LONG(0)              
    }

    .text : { *(.text) }

    /DISCARD/ : { *(.eh_frame) }
    /DISCARD/ : { *(.note.gnu.property)}
}