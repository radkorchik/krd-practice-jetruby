require 'rspec'
require_relative 'pokemon_script'

RSpec.describe '#collect_pokemons' do
  it 'создаёт массив хешей покемонов по введённым данным' do
    allow_any_instance_of(Kernel)
      .to receive(:gets)
      .and_return('2', 'Pikachu', 'Yellow', 'Charmander', 'Red')

    result = collect_pokemons

    expect(result).to eq(
      [
        { name: 'Pikachu',   color: 'Yellow' },
        { name: 'Charmander', color: 'Red' }
      ]
    )
  end
end

