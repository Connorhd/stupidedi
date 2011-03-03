module Stupidedi
  module Schema

    # @see X222 B.1.3.12.4 Loops of Data Segments
    class LoopDef
      # @return [String]
      attr_reader :id

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [Array<SegmentUse>]
      attr_reader :segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [LoopDef, TableDef]
      attr_reader :parent

      def initialize(id, repeat_count, segment_uses, loop_defs, parent)
        @id, @repeat_count, @segment_uses, @loop_defs, @parent =
          id, repeat_count, segment_uses, loop_defs, parent

        @segment_uses = @segment_uses.map{|x| x.copy(:parent => self) }
        @loop_defs    =    @loop_defs.map{|x| x.copy(:parent => self) }
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:segment_uses, @segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:parent, @parent)
      end

      # @see X222 B.1.1.3.11.1 Loop Control Segments
      # @see X222 B.1.1.3.12.4 Loops of Data Segments Bounded Loops
      def bounded?
        segment_uses.head.segment_def.id == :LS and
        segment_uses.last.segment_def.id == :LE
      end

      # @see X12.59 5.6 HL-initiated Loop
      def hierarchical?
        segment_uses.head.segment_def.id == :HL
      end

      def value(segment_vals, parent)
        LoopVal.new(self, segment_vals, [], parent)
      end

      def empty(parent)
        LoopVal.new(self, [], [], parent)
      end

      abstract :reader, :args => %w(input, context)

      # @private
      def pretty_print(q)
        q.text("LoopDef[#{@id}]")
        q.group(1, "(", ")") do
          q.breakable ""
          @segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          @loop_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << LoopDef
      def build(id, repeat_count, *args)
        segment_uses = args.take_while{|x| x.is_a?(SegmentUse) }
        loop_defs    = args.drop(segment_uses.length)

        new(id, repeat_count, segment_uses, loop_defs, nil)
      end
    end

  end
end