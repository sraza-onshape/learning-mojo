from python import Python
from python.object import PythonObject

struct Image:
    # Question[Zain] what is a reference count? how does help  object efficiently copyable?
    var rc: Pointer[Int]
    ...