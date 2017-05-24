import gocept.pseudonymize
from Crypto.Cipher import AES

import datetime
import gzip
import shutil
import base64

def apply_hash(plain_format, salt):
    h = gocept.pseudonymize.text(str(plain_format), salt)
    return h

def apply_encryption(plain_text, key, iv):

    s_plain_text = str(plain_text)

    # FOR MODE CBC, we need padding, remove if you can use mode CFB (CFB not available in R)
    length = 16 - (len(s_plain_text) % 16)
    s_plain_text += ' ' * length
    if s_plain_text == "":
        return ""
    obj = AES.new(key, AES.MODE_ECB, iv)
    enc_string = obj.encrypt(str(s_plain_text))
    done = base64.b64encode(enc_string)


    return done


def run_test():
    in_file = "/workspace/project/h3a_ingest/netmax_data/gzip/sample.tar.gz"
    out_file = "/workspace/project/h3a_ingest/netmax_data/gzip/pypy.csv"
    with gzip.open(in_file, 'rb') as fin:
        with open(out_file, 'w') as outfile:
            for line in fin.readlines():
                line_array = line.split(",")
                # last line is often empty
                if len(line_array) < 10:
                    continue

                # if bigger than 15, line corrupt
                if len(line_array[0]) > 15:
                    continue

                line_array[0] = apply_hash(line_array[0], 'secret')
                line_array[8] = apply_encryption(line_array[8], 'This is a key123', 'This is an IV456')
                line_array[9] = apply_encryption(line_array[9], 'This is a key123', 'This is an IV456')

                outfile.write(",".join(line_array))




    return out_file



