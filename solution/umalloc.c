#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "memlayout.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.

typedef long Align;

union header {
  struct {
    union header *ptr;
    uint size;
  } s;
  Align x;
};

typedef union header Header;

static Header base;
static Header *freep;

// part 2
// values to keep track of huge page pool
static Header hugebase;
static Header *hugefreep;

void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}

// TODO: implement this
// part 2
void
vfree(void *ap, uint flag)
{
  if(flag == VMALLOC_SIZE_BASE)
  {
    // free regular pages
    free(ap);
  }
  else
  {
    // free huge pages
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for(p = hugefreep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
      if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
        break;
    if(bp + bp->s.size == p->s.ptr){
      bp->s.size += p->s.ptr->s.size;
      bp->s.ptr = p->s.ptr->s.ptr;
    } else
      bp->s.ptr = p->s.ptr;
    if(p + p->s.size == bp){
      p->s.size += bp->s.size;
      p->s.ptr = bp->s.ptr;
    } else
      p->s.ptr = bp;
    hugefreep = p;
  }
}

static Header*
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
  return freep;
}

// TODO: implement
// part 2
// nearly identical to morecore(), but is called when vmalloc-ing or vfree-ing huge pages
// TODO: change the hardcoded ints to reflect this ?
// TODO: add syscall shugebrk for this function to call
//       also replace sbrk with shugebrk
static Header*
morehugecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < HUGE_PAGE_SIZE / sizeof(Header))
    nu = HUGE_PAGE_SIZE / sizeof(Header);
  p = shugebrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
  return hugefreep;
}

void*
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}

// TODO: implement this
// part 2

void*
vmalloc(uint nbytes, uint flag)
{
  if(flag == VMALLOC_SIZE_BASE)
  {
    // alloc regular pages
    return malloc(nbytes);
  }
  else
  {
    // alloc huge pages
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = hugefreep) == 0){
      hugebase.s.ptr = hugefreep = prevp = &hugebase;
      hugebase.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
      if(p->s.size >= nunits){
        if(p->s.size == nunits)
          prevp->s.ptr = p->s.ptr;
        else {
          p->s.size -= nunits;
          p += p->s.size;
          p->s.size = nunits;
        }
        hugefreep = prevp;
        return (void*)(p + 1);
      }
      if(p == hugefreep)
        if((p = morehugecore(nunits)) == 0)
          return 0;
    }
  }
}