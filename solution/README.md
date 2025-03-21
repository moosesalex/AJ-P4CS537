author: Jack Kurle
cslogin: kurle
wisc id: 9079268968
wisc email: jkurle@wisc.edu
status of submission: Not Working

changed files:
    defs.h
        added definitions for khugeinit(), khugealloc, khugefree
    exec.c
        initialized currproc->hugesz to 0
    vm.c
        modified mappages() to accommodate for hugepages
        updated kmap to include hugespace
        added allochugeuvm() to allocate huge pages
        updated deallocuvm() to dealloc base pages or huge pages based on checking PTE_PS bit
        updated freevm to do nothing if called on a hugepage
    usys.S, syscall.c
        added syscall shugebrk to system call tables and other
    user.h
        defined vmalloc huge/base flag values
        added syscall shugebrk
        added vmalloc under ulib.c
    umalloc.c
        added function vfree() to free either huge pages or base
        added function morehugecore() to grow space after allocing or freeing hugepages
        added function vmalloc to allocate base or huge pages
    sysproc.c
        defined syscall shugebrk
    proc.c
        growhugeproc, huge equivalent of growproc
    main.c
        added khugeinit to the main booting
    kalloc.c
        added new lock for protecting freehugelist
        added khugeinit, freehugerange, and khugefree and khugealloc
    