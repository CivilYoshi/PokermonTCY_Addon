local lugia = {
  name = "lugia",
  pos = {x = 0, y = 10},
  soul_pos = { x = 1, y = 10},
  config = {extra = {
    Xmult = 1.0,
	Xmult_mod = 4,
    energy_removed = 0,
    energy_threshold = 3
  }},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    -- Calculate current X multiplier based on removed energy
    local current_mult = 1 + math.floor(center.ability.extra.energy_removed / center.ability.extra.energy_threshold) * center.ability.extra.Xmult_mod
    return {vars = {
      center.ability.extra.energy_threshold,
      center.ability.extra.energy_removed,
      current_mult
    }}
  end,
  rarity = 4, -- Legendary
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  atlas = "Pokedex_GS", 
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Check if a blind is being selected (transitions to shop round)
    if context.setting_blind and not context.blueprint then
      local energy_removed = 0
      local affected_types = {"Fire", "Lightning", "Water"}
      
      -- Look for jokers with these types
      for _, joker_type in ipairs(affected_types) do
        local type_jokers = find_pokemon_type(joker_type)
        
        -- Take energy from leftmost of each type
        for _, target_joker in ipairs(type_jokers) do
          if target_joker ~= card and 
             target_joker.ability.extra and 
             (target_joker.ability.extra.energy_count or 0) + (target_joker.ability.extra.c_energy_count or 0) > 0 then
            
            -- Store the current energy counts before decreasing
            local prev_energy_count = target_joker.ability.extra.energy_count or 0
            local prev_c_energy_count = target_joker.ability.extra.c_energy_count or 0
            
            -- Determine if we're removing a colorless energy or a type energy
            local removing_colorless = prev_c_energy_count > 0
            
            -- Standard scaling properties affected by energy
            local scale_props = energy_whitelist
            
            -- Store current values before modification
            local old_values = {}
            for _, prop in ipairs(scale_props) do
              if target_joker.ability.extra[prop] then
                old_values[prop] = target_joker.ability.extra[prop]
              end
            end
            
            -- Decrease the appropriate energy counter
            if removing_colorless then
              target_joker.ability.extra.c_energy_count = prev_c_energy_count - 1
            else
              target_joker.ability.extra.energy_count = prev_energy_count - 1
            end
            
            -- Recalculate the stats based on the new energy
            for _, prop in ipairs(scale_props) do
              if target_joker.ability.extra[prop] and target_joker.config.center.config.extra[prop] then
                -- Get the base value from the center config
                local base_value = target_joker.config.center.config.extra[prop]
                
                -- Calculate the energy contribution that's being removed
                local energy_contribution = 0 
				local energy_mod_value = energy_values[prop]
                
                if removing_colorless then
                    energy_contribution = (base_value * 0.5) * (target_joker.ability.extra.escale or 1) * energy_mod_value
                  else
                    energy_contribution = base_value * (target_joker.ability.extra.escale or 1) * energy_mod_value
                end
                
				-- Subtract the energy contribution from the current value
                target_joker.ability.extra[prop] = target_joker.ability.extra[prop] - energy_contribution
                

                if target_joker.ability[prop.."_frac"] then
                  local new_frac = 0
                  if prev_energy_count > 1 then
                    new_frac = (prev_energy_count - 1) / prev_energy_count * target_joker.ability[prop.."_frac"]
                  end
                  target_joker.ability[prop.."_frac"] = new_frac
                end
              end
            end
            
            energy_removed = energy_removed + 1
            card_eval_status_text(target_joker, 'extra', nil, nil, nil, 
              {message = localize("tcy_energy_drain"), colour = G.C.RED})
            break -- Take from only the first one of each type
          end
        end
      end
      
      if energy_removed > 0 then
        card.ability.extra.energy_removed = card.ability.extra.energy_removed + energy_removed
        card_eval_status_text(card, 'extra', nil, nil, nil, 
          {message = localize("tcy_energy_absorb"), colour = G.C.BLUE})
        card:juice_up(0.8, 0.5)
      end
    end
    
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local current_mult = 1 + math.floor(card.ability.extra.energy_removed / card.ability.extra.energy_threshold) * card.ability.extra.Xmult_mod
        
        if current_mult > 1 then
          return {
            message = localize{type = 'variable', key = 'a_xmult', vars = {current_mult}},
            colour = G.C.XMULT,
            Xmult_mod = current_mult
          }
        end
      end
    end
  end
}

local hooh = {
    name = "hooh",
    pos = {x = 2, y = 10}, 
    soul_pos = { x = 3, y = 10},
    config = {extra = {Xmult = 1.0}},
    loc_vars = function(self, info_queue, center)
        type_tooltip(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return {vars = {center.ability.extra.Xmult + (0.1 * (center.ability.extra.energy_count or 0))}}
    end,
    rarity = 4,
    cost = 20,
    stage = "Legendary",
    ptype = "Fire",
    atlas = "Pokedex_GS",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and not context.blueprint and G.GAME.current_round.hands_played == 0 then
                local suits = {Hearts = false, Spades = false, Clubs = false, Diamonds = false}
                for _, played_card in ipairs(context.scoring_hand) do
                    if played_card:is_suit("Hearts") then suits.Hearts = true end
                    if played_card:is_suit("Spades") then suits.Spades = true end
                    if played_card:is_suit("Clubs") then suits.Clubs = true end
                    if played_card:is_suit("Diamonds") then suits.Diamonds = true end
                end
                
                if suits.Hearts and suits.Spades and suits.Clubs and suits.Diamonds then
                    local leftmost = context.scoring_hand[1]
                    local edition = {polychrome = true}
                    leftmost:set_edition(edition, true)
                    if not leftmost.seal then
                        local args = {guaranteed = true}
                        local seal_type = SMODS.poll_seal(args)
                        leftmost:set_seal(seal_type, true)
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            leftmost:juice_up()
                            return true
                        end
                    }))
                end
            end

            if context.joker_main then
                local polychrome_count = 0
                for _, played_card in ipairs(context.scoring_hand) do
                    if played_card.edition and played_card.edition.polychrome then
                        polychrome_count = polychrome_count + 1
                    end
                end
                
                if polychrome_count > 0 then
                    local base_mult = card.ability.extra.Xmult
                    if card.ability.extra and card.ability.extra.energy_count then
                        base_mult = base_mult + (0.1 * card.ability.extra.energy_count)
                    end

                    return {
                        message = localize('tcy_sacred_fire_ex'),
                        colour = G.C.XMULT,
                        Xmult_mod = 1 + (base_mult * polychrome_count)
                    }
                end
            end
        end
    end
}

local trapinch={
  name = "trapinch",
  pos = {x = 6, y = 7},
  poke_custom_prefix = "tcy",
  config = {extra = {
    Xmult = 1.5,
    rounds = 3
  }},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult, center.ability.extra.rounds}}
  end,
  rarity = 1,
  cost = 3,
  stage = "Basic",
  ptype = "Earth",
  atlas = "Pokedex_RS",
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Apply automatic diamond selection whenever a new hand is drawn
    if context.hand_drawn and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          for i = 1, #G.hand.cards do
            if G.hand.cards[i]:is_suit("Diamonds") then
              G.hand.cards[i].ability.forced_selection = true
              G.hand:add_to_highlighted(G.hand.cards[i])
            end
          end
          return true
        end
      }))
    end
    
	-- Apply XMult when scoring
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
          colour = G.C.XMULT,
          Xmult_mod = card.ability.extra.Xmult
		  
        }
      end
    end
    
    -- Handle card drawing mid-round (like from Tarot cards)
    if context.drawing_card and not context.blueprint then
      if context.other_card and context.other_card:is_suit("Diamonds") then
        context.other_card.ability.forced_selection = true
        G.hand:add_to_highlighted(context.other_card)
      end
    end
    
    -- Check for evolution
    return level_evo(self, card, context, "j_tcy_vibrava")
  end,
  
  load = function(self, card, card_table, other_card)
        G.E_MANAGER:add_event(Event({
        func = function()
          for i = 1, #G.hand.cards do
            if G.hand.cards[i]:is_suit("Diamonds") then
              G.hand.cards[i].ability.forced_selection = true
              G.hand:add_to_highlighted(G.hand.cards[i])
            end
          end
          return true
        end
      }))
	  end,
  
  -- Clean up forced selections when removed
  remove_from_deck = function(self, card, from_debuff)
    for k, v in ipairs(G.playing_cards) do
      v.ability.forced_selection = nil
    end
  end
}

local vibrava={
  name = "vibrava",
  pos = {x = 7, y = 7},
  poke_custom_prefix = "tcy",
  config = {extra = {
    mult = 15,
    diamonds_scored = 0
  }},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.mult, center.ability.extra.diamonds_scored}}
  end,
  rarity = "poke_safari",
  cost = 6,
  stage = "One",
  ptype = "Earth",
  atlas = "Pokedex_RS",
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Apply Mult when scoring
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult
        }
      end
    end
    
    -- Track diamond cards played
    if context.individual and context.cardarea == G.play and context.other_card:is_suit("Diamonds") and not context.blueprint then
      -- Check if this is the first diamond this round
      if not card.ability.extra.diamond_played_this_round then
        card.ability.extra.diamond_played_this_round = true
        card.ability.extra.diamonds_scored = card.ability.extra.diamonds_scored + 1
        
        -- Grant temporary +1 hand for this round
        G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
        
        return {
          message = localize('k_plus_hand'),
          colour = G.C.BLUE,
          card = card
        }
      else
        -- Just count the diamond
        card.ability.extra.diamonds_scored = card.ability.extra.diamonds_scored + 1
      end
    end
    
    -- Reset diamond tracker at end of round
    if context.end_of_round and not context.individual and not context.repetition then
      card.ability.extra.diamond_played_this_round = false
    end
    
    -- Check for evolution to Flygon based ONLY on diamond count
    return scaling_evo(self, card, context, "j_tcy_flygon", card.ability.extra.diamonds_scored, 25)
  end
}

local flygon={
  name = "flygon",
  pos = {x = 8, y = 7},
  poke_custom_prefix = "tcy",
  config = {extra = {
    Xmult = 1.0,
    Xmult_mod = 0.1,
    diamonds_enhanced = 0,
    enhanced_this_round = false
  }},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    
    -- Count enhanced diamond cards in deck
    local enhanced_diamonds = 0
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v:is_suit("Diamonds") and v.ability.name ~= "Default Base" then
          enhanced_diamonds = enhanced_diamonds + 1
        end
      end
    end
    
    local xmult_total = center.ability.extra.Xmult + (enhanced_diamonds * center.ability.extra.Xmult_mod)
    
    return {vars = {center.ability.extra.mult, xmult_total, enhanced_diamonds}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Earth",
  atlas = "Pokedex_RS",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      -- Check for leftmost diamond card in the first hand of the round
      if context.before and not card.ability.extra.enhanced_this_round and G.GAME.current_round.hands_played == 0 and not context.blueprint then
        -- Find the leftmost diamond card in the hand
        local leftmost_diamond = nil
        for i = 1, #context.scoring_hand do
          if context.scoring_hand[i]:is_suit("Diamonds") and context.scoring_hand[i].ability.name == "Default Base" then
            leftmost_diamond = context.scoring_hand[i]
            break  -- Break after finding the leftmost one
          end
        end
        
        -- Enhance the leftmost diamond card if found
        if leftmost_diamond then
          card.ability.extra.enhanced_this_round = true
          
          -- Random enhancement (excluding Stone Card)
          local enhancement_type = pseudorandom(pseudoseed('flygon_enhance'))
          local enhancement = nil
          
          if enhancement_type > 0.857 then enhancement = G.P_CENTERS.m_bonus
          elseif enhancement_type > 0.714 then enhancement = G.P_CENTERS.m_mult
          elseif enhancement_type > 0.571 then enhancement = G.P_CENTERS.m_wild
          elseif enhancement_type > 0.428 then enhancement = G.P_CENTERS.m_glass
          elseif enhancement_type > 0.285 then enhancement = G.P_CENTERS.m_steel
          elseif enhancement_type > 0.142 then enhancement = G.P_CENTERS.m_gold
          else enhancement = G.P_CENTERS.m_lucky
          end
          
          leftmost_diamond:set_ability(enhancement, nil, true)
          G.E_MANAGER:add_event(Event({
            func = function()
              leftmost_diamond:juice_up()
              return true
            end
          }))
          
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_enhance'), colour = G.C.BLUE})
        end
      end
      
      if context.joker_main then
        -- Count enhanced diamond cards in deck
        local enhanced_diamonds = 0
        for _, v in ipairs(G.playing_cards) do
          if v:is_suit("Diamonds") and v.ability.name ~= "Default Base" then
            enhanced_diamonds = enhanced_diamonds + 1
          end
        end
        
        -- Calculate total XMult
        local xmult_total = card.ability.extra.Xmult + (enhanced_diamonds * card.ability.extra.Xmult_mod)
        
        return {
          message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult + (enhanced_diamonds * card.ability.extra.Xmult_mod)}},
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult,
          Xmult_mod = xmult_total
        }
      end
    end
    
    -- Check for diamond cards being played
    if context.individual and context.cardarea == G.play and context.other_card:is_suit("Diamonds") and not context.blueprint then
      -- Track diamond cards played and give +1 hand for first diamond in round
      if not card.ability.extra.diamond_played_this_round then
        card.ability.extra.diamond_played_this_round = true
        
        -- Grant temporary +1 hand for this round
        G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
        
        return {
          message = localize('k_plus_hand'),
          colour = G.C.BLUE,
          card = card
        }
      end
    end
    
    -- Reset flags at end of round
    if context.end_of_round and not context.individual and not context.repetition then
      card.ability.extra.diamond_played_this_round = false
      card.ability.extra.enhanced_this_round = false
    end
  end
}

local spheal = {
    name = "spheal",
    pos = {x = 4, y = 11},
	poke_custom_prefix = "tcy",
    config = {extra = {
        chips = 4,         -- Base chip value
        mult = 2,          -- Starting mult value
        glass_cards = 0,   -- Tracks glass cards played
        fail_chance = 20   -- 20% chance to fail
    }},
    loc_vars = function(self, info_queue, center)
        type_tooltip(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'percent_chance', set = 'Other', specific_vars = {center.ability.extra.fail_chance}}
        return {vars = {
            center.ability.extra.chips,
            center.ability.extra.mult,
            center.ability.extra.glass_cards
        }}
    end,
    rarity = 2,
    cost = 4,
    stage = "Basic",
    ptype = "Water",
    atlas = "Pokedex_RS",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.RED,
                    chip_mod = card.ability.extra.chips,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
        if context.individual and context.cardarea == G.play and 
           not context.end_of_round and context.other_card.ability.name == 'Glass Card' then
            card.ability.extra.glass_cards = card.ability.extra.glass_cards + 1
            
            if not context.repetition and pseudorandom('spheal_rollout') < card.ability.extra.fail_chance/100 then
                card.ability.extra.mult = math.floor(card.ability.extra.mult / 2)
                card.ability.extra.chips = math.floor(card.ability.extra.chips / 2)
                
                if not context.blueprint then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('tcy_miss_ex'), colour = G.C.RED})
                end
                
            else
                card.ability.extra.chips = card.ability.extra.chips + 4
                card.ability.extra.mult = card.ability.extra.mult + 2
                
                if not context.blueprint and not context.repetition then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('tcy_rollout_ex'), colour = G.C.BLUE})
                    card:juice_up()
                end
                
            end
        end
        return scaling_evo(self, card, context, "j_tcy_sealeo", card.ability.extra.glass_cards, 2)
    end
}


local sealeo = {
    name = "sealeo",
    pos = {x = 5, y = 11},
	poke_custom_prefix = "tcy",
    config = {extra = {
        chips = 8,        -- Base chip value
        mult = 4,          -- Starting mult value  
        glass_cards = 0,   -- Tracks glass cards played
        fail_chance = 15   -- 15% chance to fail
    }},
    loc_vars = function(self, info_queue, center)
        type_tooltip(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'percent_chance', set = 'Other', specific_vars = {center.ability.extra.fail_chance}}
        return {vars = {
            center.ability.extra.chips,
            center.ability.extra.mult,
            center.ability.extra.glass_cards
        }}
    end,
    rarity = "poke_safari",
    cost = 6,
    stage = "One",
    ptype = "Water",
    atlas = "Pokedex_RS",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
                    chip_mod = card.ability.extra.chips,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
        if context.individual and context.cardarea == G.play and 
           not context.end_of_round and context.other_card.ability.name == 'Glass Card' then
            card.ability.extra.glass_cards = card.ability.extra.glass_cards + 1
            
            if not context.repetition and pseudorandom('sealeo_rollout') < card.ability.extra.fail_chance/100 then
                card.ability.extra.mult = math.floor(card.ability.extra.mult / 2)
                card.ability.extra.chips = math.floor(card.ability.extra.chips / 2)
                
                if not context.blueprint then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('tcy_miss_ex'), colour = G.C.RED})
                end
                
            else
                card.ability.extra.chips = card.ability.extra.chips + 8
                card.ability.extra.mult = card.ability.extra.mult + 4
                
                if not context.blueprint and not context.repetition then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('tcy_rollout_ex'), colour = G.C.BLUE})
                    card:juice_up()
                end
                
            end
        end
        return scaling_evo(self, card, context, "j_tcy_walrein", card.ability.extra.glass_cards, 8)
    end,
    set_ability = function(self, card)
        if card.ability.prev_card then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.prev_card.ability.extra.chips
            card.ability.extra.mult = card.ability.extra.mult + card.ability.prev_card.ability.extra.mult
            card.ability.extra.glass_cards = card.ability.prev_card.ability.extra.glass_cards
        end
    end
}

local walrein = {
   name = "walrein",
   pos = {x = 6, y = 11},
   poke_custom_prefix = "tcy",
   config = {extra = {
       chips = 12,        -- Base chip value
       mult = 6,         -- Starting mult value
       glass_cards = 0,   -- Tracks glass cards played
       fail_chance = 10,   -- 10% chance to fail when glass card played
       Xmult = 1.0,      -- Starting X Mult value
       Xmult_mod = 0.05  -- X Mult increase per glass card
   }},
   loc_vars = function(self, info_queue, center)
       type_tooltip(self, info_queue, center)
       info_queue[#info_queue+1] = {key = 'percent_chance', set = 'Other', specific_vars = {center.ability.extra.fail_chance}}
       return {vars = {
           center.ability.extra.chips,
           center.ability.extra.mult,
           center.ability.extra.glass_cards,
		   center.ability.extra.Xmult,
		   center.ability.extra.Xmult_mod,
		   center.ability.extra.Xmult + (center.ability.extra.glass_cards * center.ability.extra.Xmult_mod)
       }}
   end,
   rarity = "poke_safari",
   cost = 10,
   stage = "Two",
   ptype = "Water",
   atlas = "Pokedex_RS",
   blueprint_compat = true,
   calculate = function(self, card, context)
       if context.cardarea == G.jokers and context.scoring_hand then
           if context.joker_main then
               return {
                   message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                   colour = G.C.RED,
                   chip_mod = card.ability.extra.chips,
                   mult_mod = card.ability.extra.mult,
                   Xmult_mod = card.ability.extra.Xmult + (card.ability.extra.glass_cards * card.ability.extra.Xmult_mod)
               }
           end
       end
       if context.individual and context.cardarea == G.play and 
          not context.end_of_round and context.other_card.ability.name == 'Glass Card' then
           card.ability.extra.glass_cards = card.ability.extra.glass_cards + 1
           
           -- Check for failure (10% chance)
           if pseudorandom('spheal_rollout') < card.ability.extra.fail_chance/100 then
               card.ability.extra.mult = math.floor(card.ability.extra.mult / 2)
               card.ability.extra.chips = math.floor(card.ability.extra.chips / 2)
               
               card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('tcy_miss_ex'), colour = G.C.RED})
               
           else
               card.ability.extra.chips = card.ability.extra.chips + 12
               card.ability.extra.mult = card.ability.extra.mult + 6
               
               card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('tcy_rollout_ex'), colour = G.C.BLUE})
               card:juice_up()
               
           end
       end
   end
}

local heatran = {
  name = "heatran",
  pos = {x = 10, y = 7},
  soul_pos = {x = 11, y = 7},
  config = {extra = {triggered_editions = 0}},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
	info_queue[#info_queue+1] = G.P_CENTERS.c_immolate
    return {vars = {center.ability.extra.triggered_editions}}
  end,
  rarity = 4,
  cost = 15,
  stage = "Legendary",
  ptype = "Fire",
  atlas = "Pokedex_DP",
  blueprint_compat = true,
calculate = function(self, card, context)
  -- Gain an immolate card every Big Blind and Boss blind
  if context.setting_blind and not card.getting_sliced then
    if context.blind == G.P_BLINDS.bl_big or (context.blind and context.blind.boss) then
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        local immolate_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_immolate')
        immolate_card:add_to_deck()
        G.consumeables:emplace(immolate_card)
        card_eval_status_text(immolate_card, 'extra', nil, nil, nil, {
          message = localize('k_plus_spectral'),
          colour = G.C.SECONDARY_SET.Spectral
        })
      end
    end
  end
      
  -- When steel cards with an edition are triggered from hand
  if context.individual and context.cardarea == G.hand and context.scoring_hand then
    if context.other_card.ability.name == 'Steel Card' and context.other_card.edition then
      -- Activate edition effects
      if context.other_card.edition.polychrome then
        return {
          x_mult = 1.5,
          card = card
        }
      elseif context.other_card.edition.holo then
        return {
          mult = 10,
          card = card
        }
      elseif context.other_card.edition.foil then
        return {
          chips = 50,
          card = card
        }
      end
    end
  end
      
  -- When steel cards in hand are destroyed
  if context.remove_playing_cards and context.removed then
    for k, destroyed_card in ipairs(context.removed) do
      if destroyed_card and destroyed_card.ability and destroyed_card.ability.name == 'Steel Card' then
        -- Random edition (25% chance Polychrome, 35% Holographic, 40% Foil)
        local edition_roll = pseudorandom('heatran_edition')
        local edition = {}
        
        if edition_roll < 0.25 then
          edition = {polychrome = true}
        elseif edition_roll < 0.60 then
          edition = {holo = true}
        else
          edition = {foil = true}
        end
        
        -- Create a steel card with the same suit and rank as the destroyed card
        local new_card = create_playing_card({
          front = destroyed_card.config.card, -- Use original card's front (suit and rank) 
          center = G.P_CENTERS.m_steel
        }, G.deck, true)
        
        new_card:set_edition(edition, true)
        
        G.E_MANAGER:add_event(Event({
          func = function()
            card:juice_up()
            return true
          end
        }))
        
        card_eval_status_text(card, 'extra', nil, nil, nil, {
          message = localize('tcy_magma_storm_ex'),
          colour = G.C.BLUE
        })
        
        -- Track edition triggering
        card.ability.extra.triggered_editions = card.ability.extra.triggered_editions + 1
      end
    end
  end
end
}

local xurkitree = {
    name = "xurkitree",
    pos = {x = 4, y = 7},
    soul_pos = {x = 5, y = 7},
    config = {extra = {h_dollars = 2, h_x_mult = 1.37, Xmult = 1}},
    loc_vars = function(self, info_queue, center)
        type_tooltip(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        
        -- Count current pairs in hand
        local steel_count = 0
        local gold_count = 0
        if G.hand and G.hand.cards then
            for _, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Steel Card' then
                    steel_count = steel_count + 1
                elseif v.ability.name == 'Gold Card' then
                    gold_count = gold_count + 1
                end
            end
        end
        local current_pairs = math.min(steel_count, gold_count)
        
        return {vars = {center.ability.extra.h_dollars, center.ability.extra.h_x_mult, current_pairs + 1}}
    end,
    rarity = "tcy_ultrabeast",
    cost = 8,
    stage = "Ultra Beast",
    ptype = "Lightning",
    atlas = "Pokedex_SM",
    blueprint_compat = true,
    calculate = function(self, card, context)
        -- Handle pairs multiplier at end of hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                local steel_count = 0
                local gold_count = 0
                
                for _, v in ipairs(G.hand.cards) do
                    if v.ability.name == 'Steel Card' then
                        steel_count = steel_count + 1
                    elseif v.ability.name == 'Gold Card' then
                        gold_count = gold_count + 1
                    end
                end
                
                local pairs = math.min(steel_count, gold_count)
                if pairs > 0 then
                    return {
                        message = localize('tcy_boost_ex'),
                        colour = G.C.XMULT,
                        Xmult_mod = pairs + 1
                    }
                end
            end
        end
        
        -- Handle individual card effects in hand
        if context.individual and context.cardarea == G.hand then
            if context.other_card.ability.name == 'Steel Card' then
                return {
                    dollars = card.ability.extra.h_dollars
                }
            elseif context.other_card.ability.name == 'Gold Card' then
                return {
                    x_mult = card.ability.extra.h_x_mult,
                }
            end
        end
    end
}

local guzzlord = {
    name = "guzzlord",
    pos = {x = 10, y = 7},
    soul_pos = {x = 11, y = 7},
    config = {extra = {
        Perm_Xmult = 1,    -- Tracks permanent X mult gains (starts at 1)
        Perm_mult = 0,     -- Tracks permanent mult gains
        Perm_chips = 0,    -- Tracks permanent chip gains
		Xmult = 1,
		mult = 1,
		chips = 1,
        odds_joker = 3,    -- 1/3 chance for jokers
        odds_consumable = 3, -- 1/3 chance for consumables
        odds_discard = 13,   -- 1/13 chance for discards
        Xmult_gain = 0.29,  -- X mult gained per consume
        mult_gain = 3,      -- Mult gained per consume
        chip_gain = 11      -- Chips gained per consume
    }},
    loc_vars = function(self, info_queue, center)
        type_tooltip(self, info_queue, center)
        
        return {vars = {
            ''..(G.GAME and G.GAME.probabilities.normal or 1),  -- #1 current probability
            center.ability.extra.odds_joker,                     -- #2 odds for joker/consumable
            center.ability.extra.odds_discard,                   -- #3 odds for discard
            center.ability.extra.Perm_Xmult * center.ability.extra.Xmult,                    -- #4 current X Mult
            center.ability.extra.Perm_mult * center.ability.extra.mult,                     -- #5 current Mult
            center.ability.extra.Perm_chips * center.ability.extra.chips                    -- #6 current Chips
        }}
    end,
    rarity = "tcy_ultrabeast",
    cost = 8,
    stage = "Ultra Beast",
    ptype = "Dragon",
    atlas = "Pokedex_SM",
    blueprint_compat = true,
    calculate = function(self, card, context)
        -- Handle joker/consumable purchases and additions
        if context.card and context.card ~= card and not context.selling_self and not context.selling_card then
            -- For jokers
            if context.card.ability.set == 'Joker' then
                if pseudorandom('guzzlord_joker') < G.GAME.probabilities.normal/card.ability.extra.odds_joker then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            card.ability.extra.Perm_Xmult = card.ability.extra.Perm_Xmult + card.ability.extra.Xmult_gain
                            G.jokers:remove_card(context.card)
                            context.card:remove()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = localize('tcy_consume_ex'),
                                colour = G.C.RED
                            })
                            return true
                        end
                    }))
                end
            -- For consumables
            elseif context.card.ability.consumeable then
                if pseudorandom('guzzlord_consumable') < G.GAME.probabilities.normal/card.ability.extra.odds_consumable then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            card.ability.extra.Perm_mult = card.ability.extra.Perm_mult + card.ability.extra.mult_gain
                            G.consumeables:remove_card(context.card)
                            context.card:remove()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = localize('tcy_consume_ex'),
                                colour = G.C.RED
                            })
                            return true
                        end
                    }))
                end
            end
        end

        -- Handle discards
        if context.discard then
            if pseudorandom('guzzlord_discard') < G.GAME.probabilities.normal/card.ability.extra.odds_discard then
                -- Consume the discarded card
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card.ability.extra.Perm_chips = card.ability.extra.Perm_chips + card.ability.extra.chip_gain
                        context.other_card:start_dissolve()
                        delay(0.3)
                        for i = 1, #G.jokers.cards do
                            G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = {context.other_card}})
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('tcy_consume_ex'),
                            colour = G.C.RED
                        })
                        return true
                    end
                }))
            end
        end

        -- Apply permanent stat bonuses during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                local ret = {}
                if card.ability.extra.Perm_Xmult > 0 then
                    ret.Xmult_mod = card.ability.extra.Perm_Xmult * card.ability.extra.Xmult
                end
                if card.ability.extra.Perm_mult > 0 then
                    ret.mult_mod = card.ability.extra.Perm_mult * card.ability.extra.mult
                end
                if card.ability.extra.Perm_chips > 0 then
                    ret.chip_mod = card.ability.extra.Perm_chips * card.ability.extra.chips
                end
                
                if next(ret) then
                    ret.message = localize('tcy_boost_ex')
                    ret.colour = G.C.RED
                    return ret
                end
            end
        end
    end
}

local stakataka = {
    name = "stakataka",
    pos = {x = 12, y = 8},
    soul_pos = {x = 13, y = 8},
    config = {extra = {
        chips = 0,          -- Tracks chip gains
        Xmult = 0.17,       -- X mult gained per prime number
        prime_count = 0,    -- Tracks how many prime numbers match deck size
        next_prime = 0      -- Tracks the next prime number beyond current deck size
    }},
    loc_vars = function(self, info_queue, center)
        type_tooltip(self, info_queue, center)
        
        return {vars = {
            center.ability.extra.Xmult,      -- #1 X mult per prime number
            center.ability.extra.prime_count, -- #2 count of prime numbers
            center.ability.extra.chips,      -- #3 current Chips
            1 + (center.ability.extra.prime_count * center.ability.extra.Xmult), -- #4 total X mult
            center.ability.extra.next_prime  -- #5 next prime number target
        }}
    end,
    rarity = "tcy_ultrabeast",
    cost = 9,
    stage = "Ultra Beast",
    ptype = "Earth",
    atlas = "Pokedex_SM",
    blueprint_compat = true,
    -- Predefined list of prime numbers up to 700
    primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 
    73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 
    179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 
    283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 
    419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 
    547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 
    661, 673, 677, 683, 691, 697},
    
    -- Find the next prime after a given number
    find_next_prime = function(self, current_size)
        for _, prime in ipairs(self.primes) do
            if prime > current_size then
                return prime
            end
        end
        -- If no next prime is found in our list, return the last one + 2
        -- (just a placeholder, as we might have reached the end of our list)
        return self.primes[#self.primes] + 2
    end,
    
    calculate = function(self, card, context)
        -- Calculate prime-related bonuses at the beginning of scoring
        if context.cardarea == G.jokers and context.scoring_hand and context.before and not context.blueprint then
            -- Reset counts
            card.ability.extra.prime_count = 0
            local prime_sum = 0
            local deck_size = #G.playing_cards
            
            -- Find the next prime beyond current deck size
            card.ability.extra.next_prime = self:find_next_prime(deck_size)
            
            -- Check for prime numbers less than or equal to the deck size
            for _, prime in ipairs(self.primes) do
                if prime <= deck_size then
                    card.ability.extra.prime_count = card.ability.extra.prime_count + 1
                    prime_sum = prime_sum + prime
                end
            end
            
            -- Update chips based on cumulative sum of relevant primes
            card.ability.extra.chips = prime_sum
        end
        
        -- Apply effects when scoring
        if context.cardarea == G.jokers and context.scoring_hand and context.joker_main then
            if card.ability.extra.prime_count > 0 then
                local xmult_bonus = 1 + (card.ability.extra.prime_count * card.ability.extra.Xmult)
                
                return {
                    message = localize("tcy_boost_ex"),
                    colour = G.C.ULTRA,
                    Xmult_mod = xmult_bonus,
                    chip_mod = card.ability.extra.chips,
                    card = card
                }
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            -- Only update periodically to reduce performance impact
            card.ability.update_timer = (card.ability.update_timer or 0) + dt
            if card.ability.update_timer < 0.5 then return end
            card.ability.update_timer = 0
            
            if G.playing_cards then
                -- Reset counts
                local prime_count = 0
                local prime_sum = 0
                local deck_size = #G.playing_cards
                
                -- Find the next prime beyond current deck size
                card.ability.extra.next_prime = self:find_next_prime(deck_size)
                
                -- Check for prime numbers less than or equal to the deck size
                for _, prime in ipairs(self.primes) do
                    if prime <= deck_size then
                        prime_count = prime_count + 1
                        prime_sum = prime_sum + prime
                    end
                end
                
                -- Only update if values have changed
                if prime_count ~= card.ability.extra.prime_count or prime_sum ~= card.ability.extra.chips then
                    card.ability.extra.prime_count = prime_count
                    card.ability.extra.chips = prime_sum
                end
            end
        end
    end
}

local blacephalon = {
   name = "blacephalon",
   pos = {x = 0, y = 9},
   soul_pos = {x = 1, y = 9},
   config = {extra = {
       mult = 1,             -- Current accumulated mult
       times_disabled = 0,   -- Track number of times disabled 
       Xmult = 1.0,         -- Current Xmult value
       Xmult_mod4 = 1.0,
       current_ante = 0,     -- Track current ante for resets
       cards_discarded = 0,   -- Track discards this ante
       debuff_real = 0
   }},
   loc_vars = function(self, info_queue, center)
       type_tooltip(self, info_queue, center)
       return {vars = {
           (center.ability.extra.cards_discarded) * 3 * center.ability.extra.mult, -- Current total mult
           center.ability.extra.Xmult * center.ability.extra.Xmult_mod4 -- Current Xmult
       }}
   end,
   rarity = "tcy_ultrabeast",
   cost = 12,
   stage = "Ultra Beast",
   ptype = "Psychic",
   atlas = "Pokedex_SM",
   blueprint_compat = false,
   calculate = function(self, card, context)
       -- Initialize if needed
       if not card.ability.extra.cards_discarded then
           card.ability.extra.cards_discarded = 0
       end
       -- Reset card capabilities ONLY when ante increases
       if G.GAME.round_resets.ante ~= card.ability.extra.current_ante then
           card.ability.extra.current_ante = G.GAME.round_resets.ante  -- Store new ante
           card.ability.extra.cards_discarded = 0                      -- Reset discard counter
           card.ability.extra.debuff_real = 0
           card.debuff = false                                         -- Enable card again
       end 
       
       if card.ability.extra.debuff_real == 1 then 
           card.debuff = true
       end
       
       -- Track discards
       if context.discard and not context.blueprint then
           card.ability.extra.cards_discarded = card.ability.extra.cards_discarded + 1
       end
       -- Main scoring logic
       if context.cardarea == G.jokers and context.scoring_hand and not context.blueprint then
           if context.joker_main and G.jokers.cards[1] == card and not card.debuff then
               -- Disable card and increase permanent Xmult
               G.E_MANAGER:add_event(Event({
                   func = function()
                       card.debuff = true
                       card.ability.extra.times_disabled = card.ability.extra.times_disabled + 1
                       card.ability.extra.Xmult_mod4 = 1.0 + (card.ability.extra.times_disabled * 0.67)
                       card.ability.extra.debuff_real = 1
                       return true
                   end
               }))
               return {
                   message = localize("poke_explosion_ex"),
                   colour = G.C.MULT,
                   mult_mod = card.ability.extra.cards_discarded * 7 * card.ability.extra.mult,
                   Xmult_mod4 = 1.0 + card.ability.extra.Xmult * card.ability.extra.Xmult_mod4
               }
           end
       end
   end
}

return {name = "PokermonTCY1", 
list = {lugia, hooh, trapinch, vibrava, flygon, spheal, sealeo, walrein, heatran, xurkitree, guzzlord, stakataka, blacephalon},
}