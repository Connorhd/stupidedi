module Stupidedi
  module Envelope

    class InterchangeDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [InterchangeVal]
      abstract :empty

      # @return [InterchangeVal]
      abstract :value, :args => %w(segment_val)

      def initialize(id, header_segment_uses, trailer_segment_uses)
        @id, @header_segment_uses, @trailer_segment_uses =
          id, header_segment_uses, trailer_segment_uses
      end

      # @return [InterchangeDef]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses)
      end

      # @return [Array<SegmentUse>]
      def segment_uses
        @header_segment_uses + @trailer_segment_uses
      end

      def pretty_print(q)
        q.text("InterchangeDef[#{id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          unless q.current_group.first?
            q.text ","
            q.breakable
          end
          q.text "... (FUNCTIONAL GROUPS) ..."

          @trailer_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

  end
end