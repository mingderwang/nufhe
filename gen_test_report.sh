#!/bin/sh
pip install pytest-html
mkdir -p benchmark
pytest --capture=tee-sys --html=benchmark/test_transform.html test/test_transform
#pytest --capture=tee-sys --html=benchmark/test_api_high_level.html test/test_api_high_level.py
#pytest --capture=tee-sys --html=benchmark/test_api_low_level.html test/test_api_low_level.py
#pytest --capture=tee-sys --html=benchmark/test_numeric_functions.html test/test_numeric_functions.py
#pytest --capture=tee-sys --html=benchmark/test_tlwe.html test/test_tlwe.py
#pytest --capture=tee-sys --html=benchmark/test_polynomials.html test/test_polynomials.py
#pytest --capture=tee-sys --html=benchmark/test_lwe.html test/test_lwe.py
#pytest --capture=tee-sys --html=benchmark/test_tgsw.html test/test_tgsw.py
#pytest --capture=tee-sys --html=benchmark/test_gates.html test/test_gates.py
