from hashlib import new
from operator import contains

write_data = open("new.txt",'w')
data = [line.rstrip("\n").strip() for line in open("sort_data.txt") if line.find("?") != -1]
test_dict = set()
for url in data:
    base_url = url.split("?")[0]
    para_string = url.split("?")[1].split("&")
    para_string = [para_string_new.split("=")[0] for para_string_new in para_string]
    para_string.sort()
    new_var = (base_url,str(para_string))
    if new_var not in test_dict:
        test_dict.add(new_var)
        write_data.write(url)
        write_data.write("\n")

write_data.close()



