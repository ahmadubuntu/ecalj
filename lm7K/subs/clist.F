      subroutine clist(lstyle,slist,dclabl,z,nclass,nlist,list)
C- Generates a list of classes from a string specification
C ----------------------------------------------------------------
Ci Inputs
Ci   slist:  string specifying list of classes
Ci   lstyle: style of slist specification; see Remarks
Ci   nclass  number of classes.
Co Outputs
Co   nlist,list a list of classes satisfying specifications
Cr Remarks
Cr *Syntax of slist: depends on one of three styles (lstyle)
Cr
Cr *lstyle=1 : a list of integers; see mkilst.f for complete syntax.
Cr             Example: '1,4:6,11' generates a list of five numbers,
Cr             1,4,5,6,11.
Cr
Cr *lstyle=2 : the list is specified according to an expression.
Cr             The expression can involve the class index ic and
Cr             atomic number z.  Any class satisfying expression is
Cr             included in the list.  Example:  'ic<6&z==14'
Cr
Cr *lstyle=3 : is specifically for unix systems.  slist is a filename
Cr             with the usual unix wildcards, eg a[1-6].  'clist'
Cr             makes a system 'ls' call for that string; any class
Cr             which 'ls' finds is included in the list.
C ----------------------------------------------------------------
C     implicit none
      integer lstyle,nlist,nclass,list(1)
      character*(*) slist
      double precision z(nclass)
C Local variables
      integer iv0,ic,ival,is,i,j,ls,ls1
      logical a2bin,sw
      character strn*120,filnam*72,cnam*72
      character(8):: clabl,dclabl(nclass)
C Heap:
c      integer w(1)
c      common /w/ w
      integer,allocatable:: oilst(:)

      ls = len(slist)
      nlist = 0
c      goto (10,20,30) lstyle
      select case(lstyle*10)
C -- lstyle=1 ---
c   10 continue
      case(10)
      call mkils0(slist,nlist,i)
c      call defi(oilst, nlist)
      allocate(oilst(nlist))
      call mkilst(slist,nlist,oilst)
      if (nlist .eq. 0) return
      call ishell(nlist,oilst)
c      list(1) = w(oilst)
      list(1) = oilst(1)
      j = 1
      do  12  i = 2, nlist
c        if (w(oilst+i-1) .gt. list(j)
c     .      .and. w(oilst+i-1) .le. nclass) then
        if (oilst(i) .gt. list(j)
     .    .and. oilst(i) .le. nclass) then
          j = j+1
c          list(j) = w(oilst+i-1)
          list(j) = oilst(i)
        endif
   12 continue
      nlist = j
c       call rlse(oilst)
      return

C --- lstyle=2 ---
c   20 continue
      case(20)
      call numsyv(iv0)
      nlist = 0
      do  42  ic = 1, nclass
        call lodsyv('ic',1,dble(ic),ival)
        call lodsyv('z',1,z(ic),ival)
        is = 0
        if (a2bin(slist,sw,0,0,slist(ls:ls),is,ls)) then
          if (sw) then
            nlist = nlist+1
            list(nlist) = ic
          endif
C   ... Abort if a2bin can't parse expression
        else
          call rxs('clist: failed to parse',slist)
        endif
   42 continue
      call clrsyv(iv0)
      return

C --- lstyle=3 ---
c   30 continue
      case(30)
      nlist = 0
      call skpblb(slist,ls,ls1)
      call ffnam(slist(1:ls1+1),filnam)
      do  44  ic = 1, nclass
        call pshpr(0)
c        call r8tos8(dclabl(ic),clabl)
        clabl=dclabl(ic)
        call ffnam(clabl,cnam)
        call poppr
        call awrit0('%xls ' // filnam //'%a|grep -s '
     .    // cnam // '%a>/dev/null',strn,len(strn),0)
        call locase(strn)
        call fsystm(strn,j)
        if (j .eq. 0) then
          nlist = nlist+1
          list(nlist) = ic
        endif
   44 continue

      case default
      call rxi('clist: bad style',lstyle)
      return

      end select

      end

