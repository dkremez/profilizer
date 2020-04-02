# frozen_string_literal: true

RSpec.describe Profilizer do
  it 'has a version number' do
    expect(Profilizer::VERSION).not_to be nil
  end

  describe 'profilize' do
    before do
      stub_const('GC_PROF_REGEX',     /Objects Freed: (\d+)/.freeze)
      stub_const('MEMORY_PROF_REGEX', /Memory usage: (\d+)/.freeze)
      stub_const('TIME_PROF_REGEX',   /Time: (\d+\.\d+|\d+|\.\d+) seconds/.freeze)
    end

    context 'when full profilize' do
      let(:test_class) do
        Class.new do
          include Profilizer

          profilize def foo
            a = 1
            b = 2
            a + b
          end
        end
      end

      it 'profile time' do
        expect { test_class.new.foo }.to output(TIME_PROF_REGEX).to_stdout
      end

      it 'profile memory' do
        expect { test_class.new.foo }.to output(MEMORY_PROF_REGEX).to_stdout
      end

      it 'profile object allocation' do
        expect { test_class.new.foo }.to output(GC_PROF_REGEX).to_stdout
      end
    end

    context 'when exclude time' do
      let(:test_class) do
        Class.new do
          include Profilizer

          def foo
            a = 1
            b = 2
            a + b
          end

          profilize :foo, time: false
        end
      end

      it 'not profile time' do
        expect { test_class.new.foo }.not_to output(TIME_PROF_REGEX).to_stdout
      end
    end

    context 'when exclude memory' do
      let(:test_class) do
        Class.new do
          include Profilizer

          def foo
            a = 1
            b = 2
            a + b
          end

          profilize :foo, memory: false
        end
      end

      it 'not profile memory' do
        expect { test_class.new.foo }.not_to output(MEMORY_PROF_REGEX).to_stdout
      end
    end

    context 'when exclude Garbage Collection (GC)' do
      let(:test_class) do
        Class.new do
          include Profilizer

          def foo
            a = 1
            b = 2
            a + b
          end

          profilize :foo, gc: false
        end
      end

      it 'not profile object allocation' do
        expect { test_class.new.foo }.not_to output(GC_PROF_REGEX).to_stdout
      end
    end
  end
end
