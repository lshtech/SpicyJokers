--- STEAMODDED HEADER
--- MOD_NAME: SpicyJokers
--- MOD_ID: SpicyJokers
--- MOD_AUTHOR: [Toasterobot]
--- MOD_DESCRIPTION: This mod adds 10 New jokers with unique art
--- PREFIX: ssj
--- BADGE_COLOUR: 8B52A9

----------------------------------------------
------------MOD CODE -------------------------

local config = {

    debug = false;

}
G.localization.misc.dictionary["k_lucky"] = "Lucky"


local seven = false;
local usedConsumables = {};

-- JokerDisplay mod integration
if SMODS.Mods["JokerDisplay"] then
    NFS.load(SMODS.current_mod.path .. "/JokerDisplayIntegration.lua")()
end

SMODS.Atlas{
    key = "spicy_jokers",
    path = "sprites.png",
    px = 71,
    py = 95,
}

------------- JOKERS -------------------------

-- Edward Gun
SMODS.Joker{
    name = "Edward Gun",
    key = "gun_joker",
    loc_txt = { 
        name = "Edward Gun",
        text = {
            "{X:red,C:white}X#1#{} Mult on {C:attention}first",
            "{C:attention}hand{} of round"
        },
    },
    config = {
        extra = 3
    },
    pos = {x = 0, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}} end,
    blueprint_compat = true,
    eternal_compat = true,
    discovered = true,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra}},
                Xmult_mod = card.ability.extra
            }
        end
    end,
    
    atlas = "spicy_jokers",

}
SMODS.Joker{
    name = "Lucky Seven",
    key = 'lucky_seven',
    loc_txt = { 
        name = "Lucky Seven",
        text = {
            "All Scored cards played with a {C:attention}7{}",
            "become {C:attention}Lucky{} cards"
        },
    },
    
    config = {
        extra = 3
    },
    pos = {x = 1, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = true,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
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
                    card = card
                }
            end
        end
    end
    }

SMODS.Joker{
        name = "Business Joker",
        key = 'business_joker',

        loc_txt = { 
            name = "Business Joker",
            text = {
                "Create a {C:attention}Hermit{} {C:tarot}Tarot{}",
            "if {C:attention}round won{}",
            "with only {C:chips}1{} hand",
            "{C:inactive}(Must have room)"
            },
        },
        
        config = {
            extra = 3
        },
        pos = {x = 2, y = 0}, -- POSITION IN SPRITE SHEET
        rarity = 1,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = false,
        discovered = true,
        atlas = "spicy_jokers",
        calculate = function(self, card, context)
            if G.GAME.current_round.hands_played == 0 and context.after and G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.2,
                        func = (function()
                            (context.blueprint_card or card):juice_up(0.8, 0.8)
                                local c = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_hermit', 'sup')
                                c:add_to_deck()
                                G.consumeables:emplace(c)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Hermit", colour = G.C.PURPLE})
                    end
            end
        end

}
SMODS.Joker{
    name = "Sagittarius A*",
    key = 'void',
    loc_txt = { 
        name = "Sagittarius A*",
        text = {
            "When {C:attention}blind{} is selected,",
            "Create a {C:spectral}Black Hole{} card",
            "and {C:attention}destroy{} a random joker",
            "{C:inactive}(Must have room)"
        },
    },
    
    config = {
    },
    pos = {x = 3, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
        if context.setting_blind and not self.getting_sliced and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= self and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
            end
            local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('void')) or nil
            if joker_to_destroy and not (context.blueprint_card or self).getting_sliced then 
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({G.C.PURPLE}, nil, 1.6)
                    local card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'sup')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                return true end }))
            end
        end
    end

}
SMODS.Joker{
    name = "Joker Squad",
    key = 'joker_squad',
    loc_txt = { 
        name = "Joker Squad",
        text = {
            "{C:chips}+30{} Chips for,",
            "each {C:attention}Joker{} card",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        },
    },
    pos = {x = 4, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 1,
    cost = 3,
    config = {
        extra = 30
    },
    loc_vars = function(self, info_queue, card) return {vars = {(G.jokers and G.jokers.cards and #G.jokers.cards or 0)*30}} end,

    blueprint_compat = true,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
        if context.joker_main then
            local x = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then 
                    x = x + 1 
                end
            end
            return {
                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra * x}},
                chip_mod = card.ability.extra * x, 
                colour = G.C.CHIPS
            }
        end
    end

}
SMODS.Joker{
    name = "Antimatter Joker",
    key = 'antimatter_joker',
    desc = {
        "{C:dark_edition}+2{} Joker Slots"
    },
    loc_txt = { 
        name = "Antimatter Joker",
        text = {
            "{C:dark_edition}+2{} Joker Slots"
        },
    },
    pos = {x = 5, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 3,
    cost = 10,
    config = {
    },
    blueprint_compat = false,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    add_to_deck = function(from_debuff)
        if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 2
        end
    end,
    remove_from_deck = function(from_debuff)
        if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 2
        end
    end
}
SMODS.Joker{
    name = "Misfire",
    key = 'misfire',
    loc_txt = { 
        name = "Misfire",
        text = {
            "{C:green}#1# in #2#{} chance for",
            "{X:red,C:white} X5 {} Mult"
        },
    },
    pos = {x = 6, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 1,
    cost = 4,
    config = { extra = 5
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal,card.ability.extra}} end,
    blueprint_compat = true,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('misfire') < G.GAME.probabilities.normal/card.ability.extra then
                return {
                    message = localize{type = 'variable', key = 'a_xmult',vars = {card.ability.extra}},
                    Xmult_mod = 5
                }
            end
        end
    end


}

SMODS.Joker{
    name = "Gnarled Throne",
    key = 'gnarled_throne',
    
    loc_txt = { 
        name = "Gnarled Throne",
        text = {
            "{C:mult}+1{} Mult for each",
            "card {C:attention}sold{} ",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
        },
    },
    pos = {x = 7, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 1,
    cost = 3,
    config = { extra = 0
    },
    loc_vars =function(self,info_queue,card) return {
        vars = {card.ability.extra}} end,
    blueprint_compat = true,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
        if context.selling_card then
            card.ability.extra = card.ability.extra +1
            G.E_MANAGER:add_event(Event({
                func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra}}}); return true
                end}))
        end
        if context.joker_main and card.ability.extra > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra}},
                mult_mod = card.ability.extra,
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker{
    name = "Shocked and Rattled",
    key = 'snr',
    loc_txt = { 
        name = "Shocked and Rattled",
        text = {
            "{C:mult}+5{} Mult for each",
            "{C:attention}#1#{} Discarded",
            "{C:attention}poker hand{} changes",
            "At the end of the round",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        },
    },
    pos = {x = 8, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 1,
    cost = 4,
    config = { to_do_poker_hand = "High Card",extra = 0
    },
    loc_vars =function(self,info_queue, card) return {vars = {localize(card.ability.to_do_poker_hand, 'poker_hands'), card.ability.extra}} end,
    set_ability = function(self,card, initial, delay_sprites)
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible then _poker_hands[#_poker_hands+1] = k end
        end
        
        local old_hand = card.ability.to_do_poker_hand
        card.ability.to_do_poker_hand = nil
        while not card.ability.to_do_poker_hand do
            card.ability.to_do_poker_hand = pseudorandom_element(_poker_hands, pseudoseed("snr"))
            if card.ability.to_do_poker_hand == old_hand then card.ability.to_do_poker_hand = nil end
        end
    end,
    blueprint_compat = true,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
        if context.pre_discard then
            local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            if disp_text == card.ability.to_do_poker_hand then
                card.ability.extra = card.ability.extra + 5
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={"SHOCKED"}}}); return true
                    end}))
            end
        end
        if context.joker_main and card.ability.extra > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra}},
                mult_mod = card.ability.extra,
                colour = G.C.MULT
            }
        end
    end


}

SMODS.Joker{
    name = "Sisyphus",
    key = 'sus',
    loc_txt = { 
        name = "Sisyphus",
        text = {
            "Played {C:attention}Stone Cards{}",
            "give {X:red,C:white} X1.5{} Mult"
        },
    },
    pos = {x = 9, y = 0}, -- POSITION IN SPRITE SHEET
    rarity = 1,
    cost = 3,
    config = { extra = 1.5
    },
        ---loc_vars =function(card) return { } end,
    
    blueprint_compat = true,
    eternal_compat = false,
    discovered = true,
    atlas = "spicy_jokers",
    calculate = function(self, card, context)
        if   context.cardarea == G.play  and context.individual and context.other_card.ability.effect == "Stone Card" then
                    return {
                        x_mult = card.ability.extra,
                        card = card
                    }
                end
    end,
}

if config.debug then
    SMODS.Back{ 
        key = "test",
        name = "Test Deck",
        atlas = "spicy_jokers" , 
        pos = { x = 0, y = 0 }, 
        loc_txt = {
            name = "Test Deck",
            text = {
            "This is used for debugging/testing jokers",
            }
        },
        apply = function(back)
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_joker("j_ssj_lucky_seven", nil, false, false)
                    add_joker("j_ssj_gun_joker", nil, false, false)
                    add_joker("j_ssj_joker_squad", nil, false, false)
                    add_joker("j_ssj_void", nil, false, false)
                    add_joker("j_ssj_business_joker", nil, false, false)
                    add_joker("j_ssj_antimatter_joker", nil, false, false)
                    add_joker("j_ssj_gnarled_throne", nil, false, false)
                    add_joker("j_ssj_misfire", nil, false, false)
                    add_joker("j_ssj_sus", nil, false, false)
                    add_joker("j_ssj_snr", nil, false, false)
                    local c = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_tower', 'sup')
                                    c:add_to_deck()
                                    G.consumeables:emplace(c)
                    return true
                end
            }))
        end,
    }
end
----------------------------------------------
------------MOD CODE END----------------------