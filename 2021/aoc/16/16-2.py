def hex_to_binary(h):
  mapa = { '0': '0000', '1': '0001', '2': '0010', '3': '0011', '4': '0100', '5': '0101', '6': '0110', '7': '0111', '8': '1000', '9': '1001', 'A': '1010', 'B': '1011', 'C': '1100', 'D': '1101', 'E': '1110', 'F': '1111' }
  return ''.join([ mapa[i] for i in h ])

def mkpacket(data, remaining = '', version = None, type_id = None):
  return { 'data': data, 'remaining': remaining, 'version': version, 'type_id': type_id }

def parse_literal_packet(bits, version, type_id):
  i = 0
  packets = []

  while True:
    packets.append(bits[5*i + 1:5*i + 5])
    if bits[5*i] == '0': break
    i += 1

  return mkpacket(''.join(packets), bits[5*(i+1):], version, type_id)

def parse_operator_packet(bits, version, type_id):
  if len(bits) < 6: return mkpacket('')
  # length of subpackets
  if bits[0] == '0':
    subpackets_len = int(bits[1:16], 2)

    remaining = bits[16:]
    data = _parse_packet(remaining[:subpackets_len], [])

    packets = data['data']
    remaining = remaining[subpackets_len:]
  # number of subpackets
  elif bits[0] == '1':
    subpackets_num = int(bits[1:12], 2)

    packets = []
    remaining = bits[12:]

    while len(packets) != subpackets_num:
      data = _parse_packet(remaining, [], True)

      remaining = data['remaining']
      data = data['data']

      packets.append(data)
  
  return mkpacket(packets, remaining, version, type_id)

def _parse_packet(bits, acc=[], single=False):
  if len(bits) < 6: return mkpacket(acc)

  version   = bits[0:3]
  type_id   = bits[3:6]
  remaining = bits[6:]

  if type_id == '100':
    data = parse_literal_packet(remaining, version, type_id)
  else:
    data = parse_operator_packet(remaining, version, type_id)

  remaining = data['remaining']

  if single:
    return mkpacket(data, remaining, version, type_id)

  return _parse_packet(remaining, acc + [data], single)

def smooth(packets):
  if isinstance(packets, list):
    return [ smooth(p) for p in packets ]

  if not isinstance(packets, dict):
    return packets

  del packets['remaining']

  smooth(packets['data'])
  return packets

def parse_packet(bits):
  packets = _parse_packet(bits)
  packets = smooth(packets)
  return packets['data'][0]

def eval_packets(packets):
  if isinstance(packets, str): return int(packets, 2)

  while True:
    if packets == None: break

    if isinstance(packets['data'], list): data = [ eval_packets(p) for p in packets['data'] ]
    else: data = eval_packets(packets['data'])

    if isinstance(data, list) and len(data) == 1: return data[0]

    if isinstance(data, list): print(len(data))
    if packets['type_id'] == '000': return sum(data)
    if packets['type_id'] == '001': return reduce(lambda x, y: x * y, data)
    if packets['type_id'] == '010': return min(data)
    if packets['type_id'] == '011': return max(data)
    if packets['type_id'] == '100': return data
    if packets['type_id'] == '101':
      if data[0] > data[1]: return 1
      return 0
    if packets['type_id'] == '110':
      if data[0] < data[1]: return 1
      return 0
    if packets['type_id'] == '111':
      if data[0] == data[1]: return 1
      return 0

    packets = packets['data']

  return None

with open('input') as f:
  L = f.read().replace('\n', '')

programs = [
'C200B40A82',
'04005AC33890',
'880086C3E88112',
'CE00C43D881120',
'D8005AC2A8F0',
'F600BC2D8F',
'9C005AC2F8F0',
'9C0141080250320F1802104A08',
'005532447836402684AC7AB3801A800021F0961146B1007A1147C89440294D005C12D2A7BC992D3F4E50C72CDF29EECFD0ACD5CC016962099194002CE31C5D3005F401296CAF4B656A46B2DE5588015C913D8653A3A001B9C3C93D7AC672F4FF78C136532E6E0007FCDFA975A3004B002E69EC4FD2D32CDF3FFDDAF01C91FCA7B41700263818025A00B48DEF3DFB89D26C3281A200F4C5AF57582527BC1890042DE00B4B324DBA4FAFCE473EF7CC0802B59DA28580212B3BD99A78C8004EC300761DC128EE40086C4F8E50F0C01882D0FE29900A01C01C2C96F38FCBB3E18C96F38FCBB3E1BCC57E2AA0154EDEC45096712A64A2520C6401A9E80213D98562653D98562612A06C0143CB03C529B5D9FD87CBA64F88CA439EC5BB299718023800D3CE7A935F9EA884F5EFAE9E10079125AF39E80212330F93EC7DAD7A9D5C4002A24A806A0062019B6600730173640575A0147C60070011FCA005000F7080385800CBEE006800A30C023520077A401840004BAC00D7A001FB31AAD10CC016923DA00686769E019DA780D0022394854167C2A56FB75200D33801F696D5B922F98B68B64E02460054CAE900949401BB80021D0562344E00042A16C6B8253000600B78020200E44386B068401E8391661C4E14B804D3B6B27CFE98E73BCF55B65762C402768803F09620419100661EC2A8CE0008741A83917CC024970D9E718DD341640259D80200008444D8F713C401D88310E2EC9F20F3330E059009118019A8803F12A0FC6E1006E3744183D27312200D4AC01693F5A131C93F5A131C970D6008867379CD3221289B13D402492EE377917CACEDB3695AD61C939C7C10082597E3740E857396499EA31980293F4FD206B40123CEE27CFB64D5E57B9ACC7F993D9495444001C998E66B50896B0B90050D34DF3295289128E73070E00A4E7A389224323005E801049351952694C000'
]

for p in programs:
  data = parse_packet(hex_to_binary(p))
#  print(data)
  print(eval_packets(data))
