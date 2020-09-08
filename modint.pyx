DEF mod = 1000000007

cdef class modint:
    @staticmethod
    cdef int mod() nogil:
        return mod

    @staticmethod
    cdef modint raw(unsigned int v):
        cdef modint ret = modint.__new__(modint)
        ret.__v = v
        return ret


    def __init__(modint self, long long v):
        cdef long long x = v % mod
        if x < 0:
            x += mod
        self.__v = x


    cdef unsigned int val(modint self) nogil:
        return self.__v


    def __pos__(modint self):
        return self

    def __neg__(modint self):
        cdef modint ret = modint.__new__(modint)
        if self.__v != 0:
            ret.__v = mod - self.__v
        return ret


    cdef modint pow(modint self, long long n):
        cdef modint ret = modint.__new__(modint)
        ret.__v = modint.__internal_pow(self.__v, n)
        return ret

    cdef modint inv(modint self):
        cdef modint ret = modint.__new__(modint)
        ret.__v = self.__internal_inv()
        return ret

    def __add__(modint x, modint y):
        cdef modint ret = modint.__new__(modint)
        ret.__v = x.__v + y.__v
        if ret.__v >= mod:
            ret.__v -= mod
        return ret

    def __sub__(modint x, modint y):
        cdef modint ret = modint.__new__(modint)
        ret.__v = x.__v - y.__v
        if ret.__v >= mod:
            ret.__v += mod
        return ret

    def __mul__(modint x, modint y):
        cdef modint ret = modint.__new__(modint)
        ret.__v = <unsigned long long> x.__v * y.__v % mod
        return ret

    def __truediv__(modint x, modint y):
        cdef modint ret = modint.__new__(modint)
        ret.__v = <unsigned long long> x.__v * y.__internal_inv() % mod
        return ret

    def __pow__(modint self, long long n, object):
        cdef modint ret = modint.__new__(modint)
        ret.__v = modint.__internal_pow(self.__v, n)
        return ret

    def __eq__(modint self, modint y):
        return self.__v == y.__v

    def __ne__(modint self, modint y):
        return self.__v != y.__v


    cdef unsigned int __v    

    @staticmethod
    cdef unsigned int __internal_pow(unsigned int x, unsigned long long n) nogil:
        cdef unsigned int r = 1
        while n:
            if n & 1:
                r = <unsigned long long> r * x % mod
            x = <unsigned long long> x * x % mod
            n >>= 1
        return r

    cdef unsigned int __internal_inv(modint self) nogil:
        return modint.__internal_pow(self.__v, mod - 2)
