# Test and Benchmark for nuFHE running on a nVidia Jetson Nano

## Project:

**My JETSON Nano**

![](https://paper-attachments.dropbox.com/s_A6A3AFC2FC158B5D75F74E698A0187FD27E9B4DACF9918BB3AC1D136091B9307_1595826441012_IMG_8338.jpg)


Submit this project to [NuCypher + GitCoin Unitize Hackathon](https://gitcoin.co/issue/nucypher/hackathon/8/100023187), as follow;


![](https://paper-attachments.dropbox.com/s_A6A3AFC2FC158B5D75F74E698A0187FD27E9B4DACF9918BB3AC1D136091B9307_1595822474064_Screen+Shot+2020-07-27+at+12.00.56+PM.png)


----------
## Team:

**Our Goal is:**

    To port nucypher/nuFHE source code running on a nVIDIA Jetson Nano ARM GPU board, to generate test reports in html, and do some benchmarking on test.py.


**Team Member:**

    Ming-der Wang @mingderwang (https://gitcoin.co/mingderwang)

**Project Repo:**

- on the **nvidia_jetson_nano_benchmarks** branch
- (all html files are under benchmark/ directory in the source repo)
https://github.com/mingderwang/nufhe/tree/nvidia_jetson_nano_benchmarks

----------

## **On-line Test Report:**
https://nufhe-test-and-benchmark-on-nvidia-jetson-nano.ming-taiwan.vercel.app


![](https://paper-attachments.dropbox.com/s_A6A3AFC2FC158B5D75F74E698A0187FD27E9B4DACF9918BB3AC1D136091B9307_1595827450594_Screen+Shot+2020-07-27+at+1.23.39+PM.png)

----------
## **Live Asciinema Demo:**

https://asciinema.org/a/eSL3URvHQILCw2VaTpOyH0962


**Screenshots:**

![](https://paper-attachments.dropbox.com/s_0A81D43878E90B38D9DF3E62B87EA5F26175D77320FAB15664190E9F29841DE7_1595779964880_Screen+Shot+2020-07-26+at+6.21.54+PM.png)


**Software stacks: (jtop report)**

    NVIDIA Jetson Nano (Developer Kit Version) - Jetpack 4.3 [L4T 32.3.1]
    
     - Up Time:        0 days 4:19:37                                                                                                            Version: 2.0.0
     - Jetpack:        4.3 [L4T 32.3.1]                                                                                                           Author: Raffaello Bonghi
     - Board:                                                                                                                                     e-mail: raffaello@rnext.it
       * Board(s):     P3448-0000, P3449-0000 (3448)
       * Code Name:    porg
       * GPU-Arch:     5.3
       * SN:           1421919083224
       * SOC:          tegra210 - ID:33
       * Type:         Nano (Developer Kit Version)
     - Libraries:
       * CUDA:         10.0.326
       * OpenCV:       4.1.1 compiled CUDA: NO
       * TensorRT:     6.0.1.10
       * VisionWorks:  1.6.0.500n
       * cuDNN:        7.6.3.28


----------

## **Benchmarks of running test.py**
cat test.py

    import random
    import nufhe
    
    size = 1
    bits1 = [random.choice([False, True]) for i in range(size)]
    print(bits1)
    print("< bits 1----------")
    bits2 = [random.choice([False, True]) for i in range(size)]
    print(bits2)
    print("< bits 2----------")
    reference = [not (b1 and b2) for b1, b2 in zip(bits1, bits2)]
    print(reference)
    print("<- reference = ---------")
    
    ctx = nufhe.Context()
    print(ctx)
    print("-- ctx--------")
    print("-- waiting for secret key to generate--------")
    
    secret_key, cloud_key = ctx.make_key_pair()
    print(secret_key)
    print("-- secret key--------")
    print(cloud_key)
    print("<--- cloud key-------")
    
    ciphertext1 = ctx.encrypt(secret_key, bits1)
    print(ciphertext1)
    print("<-- ciphertext1--------")
    
    ciphertext2 = ctx.encrypt(secret_key, bits2)
    print(ciphertext2)
    print("<-- ciphertext2--------")
    
    vm = ctx.make_virtual_machine(cloud_key)
    print(vm)
    print("<----vm----")
    print(" waiting for vm.gate_nand(c1,c2)")
    
    result = vm.gate_nand(ciphertext1, ciphertext2)
    print(result)
    print("<--result = vm.gate_nand(c1,c2)--------")
    
    result_bits = ctx.decrypt(secret_key, result)
    print(result_bits)
    print("<- result_bits ---------")
    
    assert all(result_bits == reference)
    print("<- all() done ---------")

test output where size=1 
python test.py

    [True]
    < bits 1----------
    [True]
    < bits 2----------
    [False]
    <- reference = ---------
    <nufhe.api_high_level.Context object at 0x7f7bc480b8>
    -- ctx--------
    -- waiting for secret key to generate--------
    <nufhe.api_low_level.NuFHESecretKey object at 0x7f7a31ec88>
    -- secret key--------
    <nufhe.api_low_level.NuFHECloudKey object at 0x7f7a327e48>
    <--- cloud key-------
    <nufhe.lwe.LweSampleArray object at 0x7f7a327cf8>
    <-- ciphertext1--------
    <nufhe.lwe.LweSampleArray object at 0x7f73925a20>
    <-- ciphertext2--------
    <nufhe.api_high_level.VirtualMachine object at 0x7f738b9630>
    <----vm----
     waiting for vm.gate_nand(c1,c2)
    <nufhe.lwe.LweSampleArray object at 0x7f738c06d8>
    <--result = vm.gate_nand(c1,c2)--------
    [False]
    <- result_bits ---------
    <- all() done ---------

**Results:** 
It took **18.152** to run where the **size=1**

    python3 test.py  14.84s user 0.72s system 85% cpu 18.152 total

It took **58.864** to run where the **size=1997**

    python3 test.py  20.20s user 6.54s system 45% cpu 58.864 total

It took **13:54.99** to run where the **size=34141**

    python3 test.py  124.39s user 114.75s system 28% cpu 13:54.99 total
----------
## TODO:

**To further investigate the test Errors and Fails logs**

    - The compute capability of nVidia JETSON Nano is 5.3 (not > 6.0), may be the cause. (same limitation on cuFHE)
    - others should be reviewed more in details in the test report.


