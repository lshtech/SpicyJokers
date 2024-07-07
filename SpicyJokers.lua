--- STEAMODDED HEADER
--- MOD_NAME: SpicyJokers
--- MOD_ID: SpicyJokers
--- MOD_AUTHOR: [Richard]
--- MOD_DESCRIPTION: This mod doesnt do anything YET
--- BADGE_COLOUR: C9A926

----------------------------------------------
------------MOD CODE -------------------------

G.localization.misc.dictionary["k_lucky"] = "Lucky"

local Card_add_to_deck_ref = Card.add_to_deck 
function Card.add_to_deck(self, from_debuff)
    if self.ability.name == "Antimatter Joker" then
        if G.jokers then 
            G.jokers.config.card_limit = G.jokers.config.card_limit + 2
        end
    end
end

local Card_remove_from_deck_ref = Card.remove_from_deck 
function Card.remove_from_deck(self, from_debuff)
    if self.ability.name == "Antimatter Joker" then
        if G.jokers then 
            G.jokers.config.card_limit = G.jokers.config.card_limit - 2
        end
    end
end



function SMODS.INIT.SpicyJokers()
    local seven = false;
    local usedConsumables = {};

    local joker_sprites = SMODS.Sprite:new('new_jokers', SMODS.findModByID("SpicyJokers").path, "sprites.png", 71, 95, "asset_atli")
    joker_sprites:register()

    local jokers = { -- Local Joker variables
        {
            name = "Edward Gun",
            slug = 'ssj_gun_joker',
            desc = {
                "{X:red,C:white}X#1#{} Mult on {C:attention}first",
                "{C:attention}hand{} of round"
            },
            config = {
                extra = 3
            },
            pos = {x = 0, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 3,
            loc_def = function(card) return {
                card.ability.extra} end,
            blueprint_compat = true,
            eternal_compat = true
        },
        {
            name = "Lucky Seven",
            slug = 'ssj_lucky_seven',
            desc = {
                "All Scored cards played with a {C:attention}7{}",
                "become {C:attention}Lucky{} cards"
            },
            config = {
                extra = 3
            },
            pos = {x = 1, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 2,
            cost = 4,
            blueprint_compat = false,
            eternal_compat = true

        },
        {
            name = "Business Joker",
            slug = 'ssj_business_joker',
            desc = {
                "Create a {C:attention}Hermit{} {C:tarot}Tarot{}",
                "if {C:attention}round won{}",
                "with only {C:chips}1{} hand",
                "{C:inactive}(Must have room)"
            },
            config = {
                extra = 3
            },
            pos = {x = 2, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 5,
            blueprint_compat = true,
            eternal_compat = false

        },
        {
            name = "Void",
            slug = 'ssj_void',
            desc = {
                "When {C:attention}blind{} is selected,",
                "Create a {C:spectral}Black Hole{} card",
                "and {C:attention}destroy{} a random joker",
                "{C:inactive}(Must have room)"
            },
            config = {
            },
            pos = {x = 3, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 2,
            cost = 6,
            blueprint_compat = true,
            eternal_compat = false

        },
        {
            name = "Joker Squad",
            slug = 'ssj_joker_squad',
            desc = {
                "{C:chips}+30{} Chips for,",
                "each {C:attention}Joker{} card",
                "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
            },
            pos = {x = 4, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 5,
            config = {
                extra = 30
            },
            loc_def = function(card) return {(G.jokers and G.jokers.cards and #G.jokers.cards or 0)*30} end,

            blueprint_compat = true,
            eternal_compat = false

        }
        ,
        {
            name = "Antimatter Joker",
            slug = 'ssj_antimatter_joker',
            desc = {
                "{C:dark_edition}+2{} Joker Slots"
            },
            pos = {x = 5, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 3,
            cost = 12,
            config = {
            },
            blueprint_compat = false,
            eternal_compat = false

        }
        ,
        {
            name = "Misfire",
            slug = 'ssj_misfire',
            desc = {
                "{C:green}#1# in #2#{} chance for",
                "{X:red,C:white} X5 {} Mult"
            },
            pos = {x = 6, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 4,
            config = { extra = 5
            },
            loc_def =function(card) return {
                G.GAME.probabilities.normal, 
                card.ability.extra} end,
            blueprint_compat = true,
            eternal_compat = false

        }
        ,
        {
            name = "Gnarled Throne",
            slug = 'ssj_gnarled_throne',
            desc = {
                "{C:mult}+2{} Mult for each",
                "{C:attention}Unique{} consumable card",
                "used this run",
                "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
            },
            pos = {x = 7, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 4,
            config = { extra = 0
            },
            loc_def =function(card) return {
                (G.GAME.consumeable_usage and G.GAME.consumeable_usage.all or 0)} end,
            blueprint_compat = true,
            eternal_compat = false
        }
        ,
        {
            name = "Shocked and Rattled",
            slug = 'ssj_snr',
            desc = {
                "Doesnt do anything",
            },
            pos = {x = 9, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 4,
            config = { extra = 0
            },
            loc_def =function(card) return { 
                } end,
            blueprint_compat = true,
            eternal_compat = false
        }
        ,
        {
            name = "Sisyphus",
            slug = 'ssj_snr',
            desc = {
                "Doesnt do anything",
            },
            pos = {x = 10, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 4,
            config = { extra = 0
            },
            loc_def =function(card) return { 
                } end,
            blueprint_compat = true,
            eternal_compat = false
        }
    }


    for _, v in pairs(jokers) do -- ADDS Jokers to the demon
        joker = SMODS.Joker:new(
            v.name, 
            v.slug, 
            v.config,
            v.pos,
            {name = v.name, text = v.desc},
            v.rarity,
            v.cost, 
            nil, 
            nil, 
            v.blueprint_compat, 
            v.eternal_compat, 
            nil, 
            'new_jokers',
            nil
        )
        joker.loc_def = v.loc_def
        joker:register()
    end

    set_sprites_ref = Card.set_sprites
    Card.set_sprites = function(self, _center, _front)
        set_sprites_ref(self, _center, _front)
    end

    set_ability_ref = Card.set_ability
    Card.set_ability = function(self, center, initial, delay_sprites)
        set_ability_ref(self, center, initial, delay_sprites)
    end

    card_load_ref = Card.load
    Card.load = function(self, cardTable, other_card)
        card_load_ref(self, cardTable, other_card)
    end


    SMODS.Jokers.j_ssj_gun_joker.calculate = function(self, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra}},
                Xmult_mod = self.ability.extra
            }
        end
    end

    SMODS.Jokers.j_ssj_lucky_seven.calculate = function(self, context)
        if context.before and  context.cardarea == G.jokers then
            seven = false;
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 7 then seven = true end
            end
        end
        if not context.repetition and not context.other_joker and context.cardarea == G.jokers and context.before then
            if seven then
                for k, v in ipairs(context.scoring_hand) do
                    v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
                return {
                    message = localize('k_lucky'),
                    colour = G.C.MONEY,
                    card = self
                }
            end
        end
    end

    SMODS.Jokers.j_ssj_business_joker.calculate = function(self, context)
        if G.GAME.current_round.hands_played == 0 and context.after and G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_hermit', 'sup')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Hermit", colour = G.C.PURPLE})
                end
        end
    end

    SMODS.Jokers.j_ssj_void.calculate = function(self, context)
        if context.setting_blind and not self.getting_sliced and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= self and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
            end
            local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('void')) or nil
            if joker_to_destroy and not (context.blueprint_card or self).getting_sliced then 
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or self):juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({G.C.PURPLE}, nil, 1.6)
                    local card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'sup')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                return true end }))
            end
        end
    end

    SMODS.Jokers.j_ssj_joker_squad.calculate = function(self, context)
        if context.joker_main then
            local x = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then 
                    x = x + 1 
                end
            end
            return {
                message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra * x}},
                chip_mod = self.ability.extra * x, 
                colour = G.C.CHIPS
            }
        end
    end

    SMODS.Jokers.j_ssj_misfire.calculate = function(self, context)
        if context.joker_main then
            if pseudorandom('misfire') < G.GAME.probabilities.normal/self.ability.extra then
                return {
                    message = localize{type = 'variable', key = 'a_xmult',vars = {self.ability.extra}},
                    Xmult_mod = 5
                }
            end
        end
    end

    SMODS.Jokers.j_ssj_gnarled_throne.calculate = function(self, context)
        
        --if (context.playing_card_added and self.ability.set == "Joker" and not self.debuff and context.cards and context.cards[1]) then
        --    self.ability.extra = self.ability.extra + #context.cards
        --    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra}}})
        --end
        
        --if ((context.remove_playing_cards or context.destroying_card) and context.destroyed_cards and context.destroyed_cards[1] ) then 
        --    self.ability.extra = self.ability.extra + #context.destroyed_cards
        --    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra}}})
        --end

        -- if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all and G.GAME.consumeable_usage_total.all > 0 then
        --     return {
        --        message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage.all}},
        --        mult_mod = G.GAME.consumeable_usage.all
        --    }
        --end
        --if context.joker_main then 
        --    return {
        --        message = localize{type = 'variable', key = 'a_mult',vars = {self.ability.extra}},
        --        mult_mod = self.ability.extra
        --    }
        --end


    end



    -- DECK FOR TESTING

    SMODS.Deck:new("test Deck", "ssj_test", { test = true, atlas = "b_mf_grosmichel" }, { x = 0, y = 0 }, {
        name = "test Deck",
        text = {
            "Testing deck to test stuff I add{C:attention} yeaaaa"
        }
    })
    :register()
    local Back_apply_to_run_ref = Back.apply_to_run
    function Back.apply_to_run(arg)
        Back_apply_to_run_ref(arg)
    
        -- Gros Michel Deck
        if arg.effect.config.test then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_lucky_seven', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_business_joker', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_void', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_joker_squad', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_antimatter_joker', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_gnarled_throne', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    local card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_hanged_man', 'sup')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    return true
                end
            }))
        end
    end


end


----------------------------------------------
------------MOD CODE END----------------------