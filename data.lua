local newEntity = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
newEntity.name = "logistic-chest-botRequester"
newEntity.icon = "__botRequester__/graphics/icon.png"
newEntity.minable = {hardness = 0.2, mining_time = 0.5, result = "logistic-chest-botRequester"}
newEntity.max_logistic_slots = 1
newEntity.animation =
{
  layers =
  {
    {
      filename = "__botRequester__/graphics/entity.png",
      priority = "extra-high",
      width = 34,
      height = 38,
      frame_count = 7,
      shift = util.by_pixel(0, -2),
      hr_version =
      {
        filename = "__botRequester__/graphics/hr_entity.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        frame_count = 7,
        shift = util.by_pixel(0, -2),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/logistic-chest/logistic-chest-shadow.png",
      priority = "extra-high",
      width = 48,
      height = 24,
      repeat_count = 7,
      shift = util.by_pixel(8.5, 5.5),
      draw_as_shadow = true,
      hr_version =
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-shadow.png",
        priority = "extra-high",
        width = 96,
        height = 44,
        repeat_count = 7,
        shift = util.by_pixel(8.5, 5),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
}

local newItem = table.deepcopy(data.raw["item"]["logistic-chest-requester"])
newItem.name = "logistic-chest-botRequester"
newItem.place_result = "logistic-chest-botRequester"
newItem.icon = newEntity.icon
newItem.order = newItem.order .. "b"

local newRecipe = table.deepcopy(data.raw["recipe"]["roboport"])
newRecipe.name = "logistic-chest-botRequester"
newRecipe.result = "logistic-chest-botRequester"
newRecipe.icon = newEntity.icon
newRecipe.enabled = false
newRecipe.icon_size = 64


data:extend({newEntity, newItem, newRecipe})

table.insert(data.raw["technology"]["construction-robotics"].effects,{type = "unlock-recipe",recipe = "logistic-chest-botRequester"})