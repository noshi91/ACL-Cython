from libc.stdlib cimport malloc, free
 
cdef class dsu:
    cdef int _n
    cdef int *parent_or_size
 
    def __cinit__(dsu self, int n):
        cdef int *p = <int *> malloc(n * sizeof(int))
        for i in range(n):
            p[i] = -1
        self._n = n
        self.parent_or_size = p
    
    def __dealloc__(dsu self):
        free(self.parent_or_size)
    
    cdef int leader(dsu self, int a):
        if self.parent_or_size[a] < 0:
            return a
        self.parent_or_size[a] = self.leader(self.parent_or_size[a])
        return self.parent_or_size[a]
    
    cdef int same(dsu self, int a, int  b):
        return self.leader(a) == self.leader(b)
    
    cdef int size(dsu self, int a):
        return -self.parent_or_size[self.leader(a)]
    
    cdef int merge(dsu self, int a, int b):
        cdef t
        a = self.leader(a)
        b = self.leader(b)
        if a == b:
            return a
        if -self.parent_or_size[a] < -self.parent_or_size[b]:
            t = a
            a = b
            b = t
        self.parent_or_size[a] += self.parent_or_size[b]
        self.parent_or_size[b] = a
        return a