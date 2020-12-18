// mysprintf.c
// http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/17/makeos-5-2/

#include <stdarg.h>

//10進数からASCIIコードに変換
int dec2asc(char *str, int dec)
{
    int len = 0, len_buf; //桁数
    int buf[10];
    while (1)
    { //10で割れた回数（つまり桁数）をlenに、各桁をbufに格納
        buf[len++] = dec % 10;
        if (dec < 10)
            break;
        dec /= 10;
    }
    len_buf = len;
    while (len)
    {
        *(str++) = buf[--len] + 0x30;
    }
    return len_buf;
}

//16進数からASCIIコードに変換
int hex2asc(char *str, int dec)
{                         //10で割れた回数（つまり桁数）をlenに、各桁をbufに格納
    int len = 0, len_buf; //桁数
    int buf[10];
    while (1)
    {
        buf[len++] = dec % 16;
        if (dec < 16)
            break;
        dec /= 16;
    }
    len_buf = len;
    while (len)
    {
        len--;
        *(str++) = (buf[len] < 10) ? (buf[len] + 0x30) : (buf[len] - 9 + 0x60);
    }
    return len_buf;
}

/**
 * 
 */
void sprintf(char *str, char *fmt, ...)
{
    va_list list;
    int i, len;
    va_start(list, fmt);

    while (*fmt)
    {
        if (*fmt == '%')
        {
            fmt++;
            switch (*fmt)
            {
            case 'd':
                len = dec2asc(str, va_arg(list, int));
                break;
            case 'x':
                len = hex2asc(str, va_arg(list, int));
                break;
            }
            str += len;
            fmt++;
        }
        else
        {
            *(str++) = *(fmt++);
        }
    }
    *str = 0x00; //最後にNULLを追加
    va_end(list);
}

/**
 * 
 */
int strcmp(const char *src, const char *dst)
{
    int ret = 0;
    while (!(ret = *(unsigned char *)src - *(unsigned char *)dst) && *dst)
    {
        src++;
        dst++;
    }
    if (ret < 0)
        ret = -1;
    else if (ret > 0)
        ret = 1;
    return ret;
}

/**
 * 比较到前n个字符退出循环，如有一个条件不满足也退出，s1到末尾，s2到末尾则退出
 */
int strncmp(char *s1, char *s2, int n)
{
    if (!n)
        return 0;
    while (--n && *s1 && *s2 && *s1 == *s2) 
    {
        s1++;
        s2++;
    }
    return (*s1 - *s2);
}