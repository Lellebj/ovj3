/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
/*******************************************************************************
# 
# Copyright (c) 1991-1996 Varian Assoc.,Inc. All Rights Reserved. 
# This software contains proprietary and confidential 
# information of Varian Assoc., Inc. and its contributors. 
# Use, disclosure and reproduction is prohibited without 
# prior consent. 
#
# Gaussian Pulse:  256 points, 5-sigma
# This pulse is amplitude modulated and selectively excites
# a bandwidth (Hz) approximately equal to 2e+6/pulse_length
# (us).
# ***********************************************************************
# gauss: Amplitude modulated gaussian pulse: b1(x)=1023*exp(-x^2)
# ************************************************************************/
float gf[256] = {
                11.365,
                12.189,
                13.066,
                13.999,
                14.990,
                16.042,
                17.158,
                18.343,
                19.598,
                20.927,
                22.335,
                23.824,
                25.399,
                27.062,
                28.819,
                30.673,
                32.628,
                34.689,
                36.860,
                39.145,
                41.549,
                44.077,
                46.732,
                49.521,
                52.446,
                55.515,
                58.730,
                62.098,
                65.622,
                69.309,
                73.162,
                77.187,
                81.389,
                85.773,
                90.343,
                95.104,
               100.062,
               105.220,
               110.583,
               116.155,
               121.942,
               127.946,
               134.172,
               140.624,
               147.305,
               154.219,
               161.369,
               168.757,
               176.387,
               184.261,
               192.380,
               200.747,
               209.363,
               218.228,
               227.344,
               236.711,
               246.329,
               256.196,
               266.312,
               276.676,
               287.285,
               298.137,
               309.229,
               320.558,
               332.119,
               343.909,
               355.921,
               368.150,
               380.591,
               393.236,
               406.078,
               419.109,
               432.320,
               445.703,
               459.248,
               472.945,
               486.783,
               500.751,
               514.836,
               529.028,
               543.311,
               557.674,
               572.102,
               586.582,
               601.097,
               615.633,
               630.175,
               644.706,
               659.210,
               673.670,
               688.068,
               702.389,
               716.614,
               730.726,
               744.706,
               758.537,
               772.201,
               785.679,
               798.953,
               812.006,
               824.818,
               837.372,
               849.651,
               861.636,
               873.311,
               884.658,
               895.659,
               906.300,
               916.564,
               926.434,
               935.897,
               944.937,
               953.541,
               961.694,
               969.385,
               976.600,
               983.329,
               989.561,
               995.285,
              1000.492,
              1005.175,
              1009.324,
              1012.935,
              1016.000,
              1018.514,
              1020.474,
              1021.877,
              1022.719,
              1023.000,
              1022.719,
              1021.877,
              1020.474,
              1018.514,
              1016.000,
              1012.935,
              1009.324,
              1005.175,
              1000.492,
               995.285,
               989.561,
               983.329,
               976.600,
               969.385,
               961.694,
               953.541,
               944.937,
               935.897,
               926.434,
               916.564,
               906.300,
               895.659,
               884.658,
               873.311,
               861.636,
               849.651,
               837.372,
               824.818,
               812.006,
               798.953,
               785.679,
               772.201,
               758.537,
               744.706,
               730.726,
               716.614,
               702.389,
               688.068,
               673.670,
               659.210,
               644.706,
               630.175,
               615.633,
               601.097,
               586.582,
               572.102,
               557.674,
               543.311,
               529.028,
               514.836,
               500.751,
               486.783,
               472.945,
               459.248,
               445.703,
               432.320,
               419.109,
               406.078,
               393.236,
               380.591,
               368.150,
               355.921,
               343.909,
               332.119,
               320.558,
               309.229,
               298.137,
               287.285,
               276.676,
               266.312,
               256.196,
               246.329,
               236.711,
               227.344,
               218.228,
               209.363,
               200.747,
               192.380,
               184.261,
               176.387,
               168.757,
               161.369,
               154.219,
               147.305,
               140.624,
               134.172,
               127.946,
               121.942,
               116.155,
               110.583,
               105.220,
               100.062,
                95.104,
                90.343,
                85.773,
                81.389,
                77.187,
                73.162,
                69.309,
                65.622,
                62.098,
                58.730,
                55.515,
                52.446,
                49.521,
                46.732,
                44.077,
                41.549,
                39.145,
                36.860,
                34.689,
                32.628,
                30.673,
                28.819,
                27.062,
                25.399,
                23.824,
                22.335,
                20.927,
                19.598,
                18.343,
                17.158,
                16.042,
                14.990,
                13.999,
                13.066,
                12.189};
