from libc.string cimport memset
from libc.stdlib cimport malloc, free

cdef class fenwicktree:
    cdef int _n
    cdef long *data
    
    def __cinit__(fenwicktree self, int n):
        cdef long *p = <long *> malloc(n * sizeof(long))
        memset(p, 0, n * sizeof(long))
        self._n = n
        self.data = p
    
    def __dealloc__(fenwicktree self):
        free(self.data)
    
    cdef void add(fenwicktree self, int p, long x) nogil:
        p += 1
        while p <= self._n:
            self.data[p - 1] += x
            p += p & -p
    
    cdef long sum(fenwicktree self, int l, int r) nogil:
        return self.__sum__(r) - self.__sum__(l)
    
    cdef long __sum__(fenwicktree self, int r) nogil:
        cdef long s = 0
        while r > 0:
            s += self.data[r - 1]
            r -= r & -r
        return s
