--- STEAMODDED HEADER
--- MOD_NAME: SpicyJokers
--- MOD_ID: SpicyJokers
--- MOD_AUTHOR: [Richard]
--- MOD_DESCRIPTION: This mod doesnt do anything YET
--- BADGE_COLOUR: C9A926

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.SpicyJokers()
    local joker_sprites = SMODS.Sprite:new('new_jokers', SMODS.findModByID("SpicyJokers").path, "sprites.png", 71, 95, "asset_atli")
    joker_sprites:register()

    local jokers = { -- Local Joker variables
        {
            name = "Gun Joker",
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
            cost = 4,
            loc_def = function(card) return {
                card.ability.extra} end,
            blueprint_compat = true,
            eternal_compat = true
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
end
----------------------------------------------
------------MOD CODE END----------------------