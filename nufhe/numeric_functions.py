import numpy

from reikna.cluda import Module

from .numeric_functions_gpu import Torus32ToPhase
from .numeric_functions_gpu import Torus32, Int32, Float # for re-export
from .computation_cache import get_computation


# Approximate the phase to the nearest message possible in the message space.
# The constant `mspace_size` indicates on which message space we are working
# (how many messages possible).
def phase_to_t32(phase: int, mspace_size: int):
    return Torus32((phase % mspace_size) * (2**32 // mspace_size))


def t32_to_phase(thr, result, messages, mspace_size: int):
    comp = get_computation(thr, Torus32ToPhase, messages.shape, mspace_size)
    comp(result, messages)


def double_to_t32(d: float):
    return ((d - numpy.trunc(d)) * 2**32).astype(Torus32)


double_to_t32_module = Module.create(
    """
    WITHIN_KERNEL int ${prefix}(double d)
    {
        return (d - trunc(d)) * ${2**32};
    }
    """)