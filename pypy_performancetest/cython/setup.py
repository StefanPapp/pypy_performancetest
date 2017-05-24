from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = 'AnonymizeApp',
  ext_modules = cythonize("ctext.pyx"),
)