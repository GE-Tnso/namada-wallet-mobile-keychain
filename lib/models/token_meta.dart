// refactor this, do backend SSOT
class TokenMeta {
  TokenMeta._();

  static const _symbolMap = {
    'tnam1q9gr66cvu4hrzm0sd5kmlnjje82gs3xlfg3v6nu7': 'NAM',
    'tnam1pkl64du8p2d240my5umxm24qhrjsvh42ruc98f97': 'USDC',
    'tnam1p5z8ruwyu7ha8urhq2l0dhpk2f5dv3ts7uyf2n75': 'OSMO',
    'tnam1pkg30gnt4q0zn7j00r6hms4ajrxn6f5ysyyl7w9m': 'ATOM',
    'tnam1pklj3kwp0cpsdvv56584rsajty974527qsp8n0nm': 'TIA',
    'tnam1pk6pgu4cpqeu4hqjkt6s724eufu64svpqgu52m3g': 'NTRN',
    'tnam1p4px8sw3am4qvetj7eu77gftm4fz4hcw2ulpldc7': 'stOSMO',
    'tnam1p5z5538v3kdk3wdx7r2hpqm4uq9926dz3ughcp7n': 'stATOM',
    'tnam1ph6xhf0defk65hm7l5ursscwqdj8ehrcdv300u4g': 'stTIA',
    'tnam1phv4vcuw2ftsjahhvg65w4ux8as09tlysuhvzqje': 'NYM',
    'tnam1pk288t54tg99umhamwx998nh0q2dhc7slch45sqy': 'UM',
  };

  static const _iconMap = {
    'tnam1q9gr66cvu4hrzm0sd5kmlnjje82gs3xlfg3v6nu7':
        'assets/images/nam_token_yellow_black.png',
    'tnam1p5z8ruwyu7ha8urhq2l0dhpk2f5dv3ts7uyf2n75':
        'assets/images/osmo_token.png',
    'tnam1pkg30gnt4q0zn7j00r6hms4ajrxn6f5ysyyl7w9m':
        'assets/images/atom_token.png',
    'tnam1pklj3kwp0cpsdvv56584rsajty974527qsp8n0nm':
        'assets/images/tia_token.png',
    'tnam1pk6pgu4cpqeu4hqjkt6s724eufu64svpqgu52m3g':
        'assets/images/ntrn_token.png',
    'tnam1pk288t54tg99umhamwx998nh0q2dhc7slch45sqy':
        'assets/images/um_token.png',
    'tnam1p4px8sw3am4qvetj7eu77gftm4fz4hcw2ulpldc7':
        'assets/images/stosmo_token.png',
    'tnam1p5z5538v3kdk3wdx7r2hpqm4uq9926dz3ughcp7n':
        'assets/images/statom_token.png',
    'tnam1pkl64du8p2d240my5umxm24qhrjsvh42ruc98f97':
        'assets/images/usdc_token.png',
    'tnam1phv4vcuw2ftsjahhvg65w4ux8as09tlysuhvzqje':
        'assets/images/nym_token.png',
    'tnam1ph6xhf0defk65hm7l5ursscwqdj8ehrcdv300u4g':
        'assets/images/sttia_token.png',
  };

  // Most Cosmos assets use 6 decimals. Adjust if some differ.
  static const _decimalsMap = {
    'tnam1q9gr66cvu4hrzm0sd5kmlnjje82gs3xlfg3v6nu7': 6, // NAM
    'tnam1p5z8ruwyu7ha8urhq2l0dhpk2f5dv3ts7uyf2n75': 6, // OSMO
    'tnam1pkg30gnt4q0zn7j00r6hms4ajrxn6f5ysyyl7w9m': 6, // ATOM
    'tnam1pklj3kwp0cpsdvv56584rsajty974527qsp8n0nm': 6, // TIA
    'tnam1pk6pgu4cpqeu4hqjkt6s724eufu64svpqgu52m3g': 6, // NTRN
    'tnam1pk288t54tg99umhamwx998nh0q2dhc7slch45sqy': 6, // PENUMBRA
    'tnam1p4px8sw3am4qvetj7eu77gftm4fz4hcw2ulpldc7': 6, // stOSMO
    'tnam1p5z5538v3kdk3wdx7r2hpqm4uq9926dz3ughcp7n': 6, // stATOM
    'tnam1pkl64du8p2d240my5umxm24qhrjsvh42ruc98f97': 6, // USDC
    'tnam1phv4vcuw2ftsjahhvg65w4ux8as09tlysuhvzqje': 6, // NYM
    'tnam1ph6xhf0defk65hm7l5ursscwqdj8ehrcdv300u4g': 6, // stTIA
  };

  static String symbolOf(String address) => _symbolMap[address] ?? address;

  static String iconOf(String address) =>
      _iconMap[address] ?? 'assets/images/default_token_icon.png';

  static int decimalsOf(String address) => _decimalsMap[address] ?? 6;
}
