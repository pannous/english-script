require_relative 'emitter'
class Cemitter
    def if_then_else context, node
      call(:checkCondition)
    end
end
