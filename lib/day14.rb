require 'pry'

class Day14

  # recursively walk down ingredients until get one level above ore.  return back list of those ingredients
  # and quantities. at top level, sum up like ingredients
  def part1

    ingredient_map = {}
    reactions = parse_reactions(ingredient_map, "lib/day14-test1b.txt")
    output_map = reactions.map { |reaction| [reaction.output.ingredient.material, reaction] }.to_h
    fuel_reaction = output_map["FUEL"]
    ris = ingredients_required(output_map, fuel_reaction)
    binding.pry
    ris = consolidate_ingredients(ris)
    binding.pry
    ris.map do |ri|
      r = output_map[ri.ingredient.material]
      x = (ri.quantity / r.output.quantity).ceil * r.inputs[0].quantity
      x
    end
  end

  def consolidate_ingredients(reaction_ingredients)
    h = {}
    reaction_ingredients.each do |ri|
      e =  h[ri.ingredient.material]
      if e
        e.quantity += ri.quantity
      else
        h[ri.ingredient.material] = ri
      end
    end
    h.values
  end

  def ingredients_required(output_map, reaction)
    reaction.inputs.map do |reaction_ingredient|
      child_reaction = output_map[reaction_ingredient.ingredient.material]
      if child_reaction.inputs.size == 1 && child_reaction.inputs[0].ingredient.material == "ORE"
        [ reaction_ingredient ]
      else
        ingredients_required(output_map, child_reaction).map do |ri2|
          if ri2.ingredient.material == "DCFZ"
            binding.pry
          end
          ri2.quantity = reaction_ingredient.quantity * ri2.quantity / child_reaction.output.quantity
          ri2
        end
      end
    end.flatten
  end

  #    think i need to track leftovers too to share across reaction ingredients
  #    maybe don't try and cache?  just return all outputs from a reaction (includes final output plus left
  def ore_required(output_map, reaction_ingredient)
    if reaction_ingredient.ingredient.ore_required != -1
      ore_required = reaction_ingredient.ingredient.ore_required
      produced = reaction_ingredient.ingredient.produced
# PNFB 157 ore required 4 produced
      # if need 8
      # ceil(8/4)*157
      return (reaction_ingredient.quantity.to_f / produced).ceil * ore_required
    else
      reaction = output_map[reaction_ingredient.ingredient.material]
      if reaction.inputs.size == 1 && reaction.inputs[0].ingredient.material == "ORE"
        input = reaction.inputs[0]
        output = reaction.output
        output.ingredient.ore_required = input.quantity
        output.ingredient.produced = output.quantity
        [ input.quantity, output.quantity ]
      else
        reaction.inputs.map { |input| ore_required(output_map, input) }.sum
      end
    end
  end



  class Ingredient
    attr_accessor :material, :ore_required, :produced
    def initialize(material)
      @material = material
      @ore_required = -1
    end
  end

  class ReactionIngredient
    attr_accessor :ingredient, :quantity
    def initialize(ingredient, quantity)
      @ingredient = ingredient
      @quantity = quantity
    end
  end

  class Reaction
    attr_accessor :inputs, :output

    def initialize
      @inputs = []
    end

    def add_input_ingredient(ingredient)
      @inputs << ingredient
    end
  end

  def parse_reactions(ingredient_map, file)
    File.read(file).split("\n").map do |line|
      parts = line.split("=>")
      reaction = Reaction.new
      reaction.output = parse_reaction_ingredient(ingredient_map, parts[1])
      reaction.inputs = parts[0].split(",").map {|i| parse_reaction_ingredient(ingredient_map, i) }
      reaction
    end
  end

  def parse_reaction_ingredient(ingredient_map, str)
    parts = str.strip.split(" ")
    quantity = parts[0].to_i
    material = parts[1]
    ingredient = ingredient_map[material]
    if ingredient.nil?
      ingredient = Ingredient.new(material)
      ingredient_map[ingredient.material] = ingredient
    end
    ReactionIngredient.new(ingredient, quantity)
  end
end
