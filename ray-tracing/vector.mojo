from math import rsqrt  # performs element-wise reciprocal sqrt ops on a vector


@register_passable("trivial")
struct Vec3f:
    """Wrapper around an array - reprs a vector in 3D (e.g., a RGB pixel)."""
    var data: SIMD[DType.float32, 4]  # a 1x4 array?

    '''Initializer methods.'''
    @always_inline
    fn __init__(x: Float32, y: Float32, z: Float32) -> Self:
        """Convenience wrapper for the other constructor (below)."""
        return Vec3f {data: SIMD[DType.float32, 4](x, y, z, 0)}

    @always_inline
    fn __init__(data: SIMD[DType.float32, 4]) -> Self:
        return Vec3f {data: data}

    @always_inline
    @staticmethod
    fn zero() -> Vec3f:
        return Vec3f(0, 0, 0)

    '''Vector op methods.'''
    @always_inline
    fn __sub__(self, other: Vec3f) -> Vec3f:
        return self.data - other.data  # Question[Zain]: why isn't the rettype SIMD[DType.float32, 4]?

    @always_inline
    fn __add__(self, other: Vec3f) -> Vec3f:
        return self.data + other.data

    @always_inline
    fn __matmul__(self, other: Vec3f) -> Float32:
        '''Time to do a dot product.'''
        return (self.data * other.data).reduce_add()

    @always_inline
    fn __mul__(self, k: Float32) -> Vec3f:
        return self.data * k  # Question[Zain]: why isn't the rettype SIMD[DType.float32, 4]?

    @always_inline
    fn __neg__(self) -> Vec3f:
        return self.data * -1.0

    @always_inline
    fn __getitem__(self, idx: Int) -> SIMD[DType.float32, 1]:
        return self.data[idx]  # why isnt' this Float32? How could I make it be, if I wanted?

    @always_inline
    fn cross(self, other: Vec3f) -> Vec3f:
        let self_zxy = self.data.shuffle[2, 0, 1, 3]()
        let other_zxy = other.data.shuffle[2, 0, 1, 3]()
        return (self_zxy * other.data - self.data * other_zxy).shuffle[
            2, 0, 1, 3
        ]()
    
    @always_inline
    fn normalize(self) -> Vec3f:
        return self.data * rsqrt(self @ self)  # see the C++ tutorial - why is this so fast?? 