def hex_to_binary(h):
  mapa = { '0': '0000', '1': '0001', '2': '0010', '3': '0011', '4': '0100', '5': '0101', '6': '0110', '7': '0111', '8': '1000', '9': '1001', 'A': '1010', 'B': '1011', 'C': '1100', 'D': '1101', 'E': '1110', 'F': '1111' }
  return ''.join([ mapa[i] for i in h ])

def parse_literal_packet(bits, version, type_id):
  i = 0
  packets = []

  while True:
    packets.append(bits[5*i + 1:5*i + 5])
    if bits[5*i] == '0': break
    i += 1

  return { 'data': ''.join(packets), 'size': 5*(i+1), 'version': version, 'type_id': type_id }

def parse_operator_packet(bits, version, type_id):
  if len(bits) < 6: return { 'data': None, 'size': len(bits), 'version': version, 'type_id': type_id }

  if bits[0] == '0': length = 15
  else: length = 11

  length += 1 # for the length bit

  if bits[1:length + 1] == '': return { 'data': None, 'size': length, 'version': version, 'type_id': type_id }

  subpackets_length = int(bits[1:length], 2)
  read_bits = length + subpackets_length

  packets = []

  i = length

  while True:
    data = parse_packet(bits[i:])
    if not data or not data['data']: break
    packets.append(data['data'])
    i += data['size']

  return { 'data': packets, 'size': i, 'version': version, 'type_id': type_id }

def parse_packet(bits):
  if len(bits) < 6: return { 'data': None, 'size': len(bits) }

  version = bits[0:3]
  type_id = bits[3:6]

  read_bits = len(version) + len(type_id)

  if type_id == '100':
    data = parse_literal_packet(bits[6:], version, type_id)
    read_bits += data['size']
  else:
    data = parse_operator_packet(bits[6:], version, type_id)
    read_bits += data['size']

  return { 'data': data, 'size': read_bits, 'version': version, 'type_id': type_id }

def sum_versions(packets):
  if not isinstance(packets, dict): return 0

  size = 0

  while True:
    if packets == None: break

    if isinstance(packets, list):
      size += sum([ sum_versions(p) for p in packets ])
      return size
    if isinstance(packets, str): break
    else:
      size += int(packets['version'], 2)

    packets = packets['data']

  return size

with open('input') as f:
  L = f.read().replace('\n', '')

data = parse_packet(hex_to_binary(L))

print(sum_versions(data))
