local beastball = {
  name = "beastball",
  key = "beastball",
  set = "Spectral",
  loc_vars = function(self, info_queue, center)
   info_queue[#info_queue+1] = {set = 'Other', key = 'ultrabeast'}
  end,
  pos = { x = 5, y = 5 },
  soul_pos = { x = 6, y = 5 },
  atlas = "mart_tcy",
  cost = 4,
  pokeball = true,
  hidden = true,
  soul_set = "Planet",
  soul_rate = .007,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
        return true
    else
        return false
    end
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        local _card = create_random_poke_joker("beastball", "Ultra Beast")
        _card:add_to_deck()
        G.jokers:emplace(_card)
        return true end }))
    delay(0.6)
  end
}

local loveball = {
  name = "loveball",
  key = "loveball",
  set = "Item",
  pos = { x = 7, y = 5 },
  atlas = "mart_tcy",
  cost = 4,
  pokeball = true,
  hidden = true,
  helditem = true,
  soul_set = "Item",
  soul_rate = .008,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('timpani')
      
      -- Get all Pokemon jokers the player has used
      local joker_usage = {}
      local valid_jokers = {}
      
      -- Check both possible prefixes
      local prefixes = {"j_poke_", "j_tcy_"}
      
      -- check profile stats if they exist
      if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].joker_usage then
        for key, data in pairs(G.PROFILES[G.SETTINGS.profile].joker_usage) do
          -- Check for any Pokemon joker prefix
          local is_pokemon = false
          local prefix = ""
          for _, p in ipairs(prefixes) do
            if string.sub(key, 1, string.len(p)) == p then
              is_pokemon = true
              prefix = p
              break
            end
          end
          
          if is_pokemon then
            joker_usage[key] = (data.count or 0) + (joker_usage[key] or 0)
            valid_jokers[key] = true
          end
        end
      end
      
      local sorted_jokers = {}
      for key, count in pairs(joker_usage) do
        table.insert(sorted_jokers, {key = key, count = count})
      end
      
      -- Sort by usage count (descending)
      table.sort(sorted_jokers, function(a, b) return a.count > b.count end)
      
      -- Filter and get top 8 non-legendary, non-ultra beast Pokemon from unique families
      local top_jokers = {}
      local used_families = {}
      
      for _, joker_data in ipairs(sorted_jokers) do
        local joker_key = joker_data.key
        local center = G.P_CENTERS[joker_key]
        
        -- Extract the Pokémon name from the key
        local poke_name = nil
        for _, prefix in ipairs(prefixes) do
          if string.sub(joker_key, 1, string.len(prefix)) == prefix then
            poke_name = string.sub(joker_key, string.len(prefix) + 1)
            break
          end
        end
        
        -- Only process if we have a valid Pokemon name
        if poke_name then
          -- Find which family this Pokémon belongs to
          local family_id = nil
          for fam_id, family_group in ipairs(family) do
            for _, pokemon in ipairs(family_group) do
              local name = (type(pokemon) == "table" and pokemon.name) or pokemon
              if name == poke_name then
                family_id = fam_id
                break
              end
            end
            if family_id then break end
          end
          
          -- Check if it's a valid Pokemon and from a new family
          if center and center.stage and 
             center.stage ~= "Legendary" and 
             center.stage ~= "Ultra Beast" and
             center.set == "Joker" and
             center.stage ~= "Other" and
             family_id and not used_families[family_id] then
             
            table.insert(top_jokers, joker_key)
            used_families[family_id] = true
            
            -- Break once we have 8
            if #top_jokers >= 8 then
              break
            end
          end
        end
      end
      
      -- If we don't have any top jokers, create a random basic Pokémon
      if #top_jokers == 0 then
        local _card = create_random_poke_joker("loveball", "Basic")
        _card:add_to_deck()
        G.jokers:emplace(_card)
        return true
      end
      
      -- Pick one of the top jokers randomly
      local chosen_key = pseudorandom_element(top_jokers, pseudoseed("loveball" .. os.time()))
      
      -- Find the basic form of the chosen Pokemon
      local final_key = chosen_key
      
      -- Determine the prefix and pokemon name
      local chosen_prefix = ""
      local chosen_name = ""
      
      for _, prefix in ipairs(prefixes) do
        if string.sub(chosen_key, 1, string.len(prefix)) == prefix then
          chosen_prefix = prefix
          chosen_name = string.sub(chosen_key, string.len(prefix) + 1)
          break
        end
      end
      
      -- Look through the family array to find the basic form
      for _, family_group in ipairs(family) do
        for i, pokemon in ipairs(family_group) do
          local poke_name = (type(pokemon) == "table" and pokemon.name) or pokemon
          
          if poke_name == chosen_name then
            -- Found the Pokémon in this family, get the basic form
            local basic_name = (type(family_group[1]) == "table" and family_group[1].name) or family_group[1]
            final_key = chosen_prefix .. basic_name
            break
          end
        end
        
        if final_key ~= chosen_key then
          break
        end
      end
      
      local _card = SMODS.create_card({set = "Joker", area = G.jokers, key = final_key})
      
      local edition_type = pseudorandom_element({"holo", "foil"}, pseudoseed("loveball_edition" .. os.time()))
      local edition = {[edition_type] = true}
      _card:set_edition(edition, true)
      
      _card:add_to_deck()
      G.jokers:emplace(_card)
      
      return true 
    end }))
    delay(0.6)
  end
}

return {name = "Items",
      list = {beastball, loveball}
}