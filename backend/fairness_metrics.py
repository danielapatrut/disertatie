import numpy as np
import pdb


def error_measure(sensitive_attr, results, expected):

    if (len(sensitive_attr) != len(results)):

        raise ValueError('Inputs do not have same length')

    if len(sensitive_attr) != len(expected):

        raise ValueError('Inputs do not have same length')


    privileged_index, = np.where(sensitive_attr == 1)
    discriminated_index, = np.where(sensitive_attr == 0)

    privileged_res_one_error, = np.where(results[privileged_index] - expected[privileged_index])
    privileged_res_zero_error, = np.where(results[discriminated_index] - expected[discriminated_index])

    measure_of_error = np.abs((len(privileged_res_one_error) / len(privileged_index)) - (len(privileged_res_zero_error) / len(discriminated_index)))

    return measure_of_error, len(privileged_res_one_error) / len(privileged_index), len(privileged_res_zero_error) / len(discriminated_index)

def disp_impact(sensitive_attr, results):

    if len(sensitive_attr) != len(results):
        raise ValueError('Inputs do not have the same length')

    privileged_index, = np.where(sensitive_attr == 1)
    
    privileged_res = results[privileged_index]

    unfair_extent = len(np.where(privileged_res == 0)) / len(np.where(privileged_res == 1))

    if unfair_extent <= 0.79:
        unfair = True
    else:
        unfair = False

    return unfair, 1 - unfair_extent


def demographic_parity(sensitive_attr, results):

    if len(sensitive_attr) != len(results):
        raise ValueError('Inputs do not have same length')

    privileged_index, = np.where(sensitive_attr == 1)
    discriminated_index, = np.where(sensitive_attr == 0)

    value_discrim = np.abs(len(np.where(results[privileged_index] == 1)) / len(results) - len(np.where(results[discriminated_index] == 0)) /len(results))

    return value_discrim


