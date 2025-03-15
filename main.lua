SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
}):register()

SMODS.Atlas({
    key = "mart_tcy",
    path = "mart_tcy.png",
    px = 71,
    py = 95
}):register()

SMODS.Atlas({
  key = "Pokedex_GS",
  path = "Pokedex_GS.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Shinydex_GS",
  path = "Shinydex_GS.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Pokedex_RS",
  path = "Pokedex_RS.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Shinydex_RS",
  path = "Shinydex_RS.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Pokedex_DP",
  path = "Pokedex_DP.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Shinydex_DP",
  path = "Shinydex_DP.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Pokedex_BW",
  path = "Pokedex_BW.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Shinydex_BW",
  path = "Shinydex_BW.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Pokedex_SM",
  path = "Pokedex_SM.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "Shinydex_SM",
  path = "Shinydex_SM.png",
  px = 71,
  py = 95
}):register()

--Load Custom Rarities
SMODS.Rarity{
    key = "ultrabeast",
    default_weight = 0,
    badge_colour = HEX("2834AC"),
    pools = {["Joker"] = true},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

table.insert(family, {"trapinch", "vibrava", "flygon"})
table.insert(family, {"spheal", "sealeo", "walrein"})
table.insert(family, {"larvesta", "volcarona"})


mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end


local pconsumables = NFS.getDirectoryItems(mod_dir.."consumables")

if (SMODS.Mods["Pokermon"] or {}).can_load and SMODS.Mods["Pokermon"] then
  for _, file in ipairs(pconsumables) do
    sendDebugMessage ("The file is: "..file)
    local consumable, load_error = SMODS.load_file("consumables/"..file)
    if load_error then
      sendDebugMessage ("The error is: "..load_error)
    else
      local curr_consumable = consumable()
      if curr_consumable.init then curr_consumable:init() end
      
      for i, item in ipairs(curr_consumable.list) do
        if ((not pokermon_config.jokers_only and not item.pokeball) or (item.pokeball and pokermon_config.pokeballs)) or (item.evo_item and not pokermon_config.no_evos) then
          SMODS.Consumable(item)
        end
      end
    end
  end 
end



-- Get mod path and load other files
mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

print("DEBUG")

--Load pokemon file
local pfiles = NFS.getDirectoryItems(mod_dir.."pokemon")
if (SMODS.Mods["Pokermon"] or {}).can_load and SMODS.Mods["Pokermon"] then
  for _, file in ipairs(pfiles) do
    sendDebugMessage ("The file is: "..file)
    local pokemon, load_error = SMODS.load_file("pokemon/"..file)
    if load_error then
      sendDebugMessage ("The error is: "..load_error)
    else
      local curr_pokemon = pokemon()
      if curr_pokemon.init then curr_pokemon:init() end
      
      if curr_pokemon.list and #curr_pokemon.list > 0 then
        for i, item in ipairs(curr_pokemon.list) do
          if (pokermon_config.jokers_only and not item.joblacklist) or not pokermon_config.jokers_only  then
            item.discovered = true
            if not item.key then
              item.key = item.name
            end
            if not pokermon_config.no_evos and not item.custom_pool_func then
              item.in_pool = function(self)
                return pokemon_in_pool(self)
              end
            end
            if not item.config then
              item.config = {}
            end
            if item.ptype then
              if item.config and item.config.extra then
                item.config.extra.ptype = item.ptype
              elseif item.config then
                item.config.extra = {ptype = item.ptype}
              end
            end
            if item.item_req then
              if item.config and item.config.extra then
                item.config.extra.item_req = item.item_req
              elseif item.config then
                item.config.extra = {item_req = item.item_req}
              end
            end
            if item.evo_list then
              if item.config and item.config.extra then
                item.config.extra.evo_list = item.evo_list
              elseif item.config then
                item.config.extra = {item_req = item.evo_list}
              end
            end
            if pokermon_config.jokers_only and item.rarity == "poke_safari" then
              item.rarity = 3
            end
            item.discovered = not pokermon_config.pokemon_discovery 
            SMODS.Joker(item)
          end
        end
      end
    end
  end
end 

local pokecolors = loc_colour
function loc_colour(_c, _default)
  if not G.ARGS.LOC_COLOURS then
    pokecolors()
  end
  G.ARGS.LOC_COLOURS["ultrabeast"] = HEX("2834AC")
  return pokecolors(_c, _default)
end