#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <mach-o/dyld.h>

void listImages (void)
{
    uint32_t count = _dyld_image_count();
    printf ("Got %d images\n", count);
    for (uint32_t idx = 0; idx < count; idx++) {
        printf ("%d: %p\t%s\t(slide: %p)\n", 
            idx, 
            _dyld_get_image_header(idx), 
            _dyld_get_image_name(idx), 
            (void *)_dyld_get_image_vmaddr_slide(idx));
    }
}

void add_image_callback(const struct mach_header* mh, intptr_t vmaddr_slide)
{
    Dl_info info;
    dladdr(mh, &info);
    printf ("Add image callback invoked for image: %p %s (slide: %p)\n", mh, info.dli_fname, (void *)vmaddr_slide);
}

// void remove_image_callback(const struct mach_header* mh, intptr_t vmaddr_slide)
// {
//     Dl_info info;
//     dladdr(mh, &info);
//     printf ("Remove image callback invoked for image: %p %s (slide: %p)\n", mh, info.dli_fname, (void *)vmaddr_slide);
// }

int main (int argc, char** argv)
{
    listImages();
    _dyld_register_func_for_add_image(add_image_callback);
    // _dyld_register_func_for_remove_image(remove_image_callback);

    return 0;
}