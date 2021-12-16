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

def _parse_packet(bits, acc = [], single = False):
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
  if isinstance(packets, str):
    return int(packets, 2)

  while True:
    # different eval strategy as operator can have multiple elements
    if isinstance(packets['data'], list): data = [ eval_packets(p) for p in packets['data'] ]
    else: data = eval_packets(packets['data'])

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

with open('input') as f:
  L = f.read().replace('\n', '')

data = parse_packet(hex_to_binary(L))
print(eval_packets(data))
