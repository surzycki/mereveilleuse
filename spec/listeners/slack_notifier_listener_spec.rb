describe SlackNotifierListener do
  subject  { SlackNotifierListener.new }
  
  let(:account)  { spy('account') }
  let(:results)  { spy('results') }
  let(:errors)   { spy('errors') }
  let(:search)   { build_stubbed(:search) }

  describe '#initialize' do
    it 'initializes' do
      expect { SlackNotifierListener.new }.to_not raise_error
    end
  end 

  describe '#login' do
    context 'success' do
      it 'queues a notifier' do
        expect {
          subject.login account, 'redirect_path'
        }.to enqueue_a(SlackNotifierJob)
      end
    end

    context 'without account' do
      it 'doe NOT queue a notifier' do
        expect {
          subject.login nil, 'redirect_path'
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end

    context 'without redirect_path' do
      it 'queues a notifier' do
        expect {
          subject.login account, nil
        }.to enqueue_a(SlackNotifierJob)
      end
    end
  end

  describe '#signup' do
    context 'success' do
      it 'queues a notifier' do
        expect {
          subject.signup account
        }.to enqueue_a(SlackNotifierJob)
      end
    end

    context 'without account' do
      it 'does NOT queue a notifier' do
        expect {
          subject.signup nil
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end
  end

  describe '#authentication_fail' do
    context 'success' do
      it 'queues a notifier' do
        expect {
          subject.authentication_fail errors
        }.to enqueue_a(SlackNotifierJob)
      end
    end

    context 'without errors object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.authentication_fail nil
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end
  end

  describe '#recommendation_created' do
    let(:recommendation)  { build_stubbed :recommendation }

    context 'success' do
      context 'recommendations count 1' do
        it 'queues a notifier' do
          expect {
            subject.recommendation_created recommendation
          }.to enqueue_a(SlackNotifierJob).with(
            "*#{recommendation.recommender.fullname} signed up* by recommending *#{recommendation.practitioner.fullname}*"
          )
        end
      end

      context 'recommendations greater that 1' do
        let(:recommender)  { recommendation.recommender }

        it 'queues a notifier' do
          allow(recommender.recommendations).to receive(:count).and_return 2
          
          expect {
            subject.recommendation_created recommendation
          }.to enqueue_a(SlackNotifierJob).with(
            "*#{recommendation.recommender.fullname}* recommended *#{recommendation.practitioner.fullname}*"
          )
        end
      end
    end

    context 'without recommendation object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.recommendation_created nil
         }.to_not enqueue_a(SlackNotifierJob)
      end
    end
  end

  describe '#recommendation_create_fail' do
    context 'success' do
      it 'queues a notifier' do
        expect {
          subject.recommendation_create_fail errors
        }.to enqueue_a(SlackNotifierJob)
      end
    end

    context 'without errors object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.recommendation_create_fail nil
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end
  end

  describe '#search_success' do
    context 'success' do
      context 'results is ActiveJob' do

        it 'queues a notifier' do
          allow(results).to receive(:is_a?).and_return true

          expect {
            subject.search_success results, search
          }.to enqueue_a(SlackNotifierJob).with(
            "*#{search.user.fullname}* queued #{search}"
          )
        end
      end

      context 'results NOT an ActiveJob' do
        context 'when count NOT zero' do
          it 'queues a notifier' do
            allow(results).to receive(:count).and_return 1
            
            expect {
              subject.search_success results, search
            }.to enqueue_a(SlackNotifierJob).with(
              "*#{search.user.fullname}* was sent #{search}"
            )
          end
        end
        
        context 'when count zero' do
          it 'queues a notifier' do
            expect {
              subject.search_success results, search
            }.to_not enqueue_a(SlackNotifierJob)
          end
        end
      end
    end

    context 'without search object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.search_success results, nil
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end

    context 'without results object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.search_success nil, search
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end

    context 'without any object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.search_success nil, nil
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end
  end

  describe '#search_fail' do
    context 'success' do
      it 'queues a notifier' do
        expect {
          subject.search_fail errors
        }.to enqueue_a(SlackNotifierJob)
      end
    end

    context 'without errors object' do
      it 'does NOT queue a notifier' do
        expect {
          subject.search_fail nil
        }.to_not enqueue_a(SlackNotifierJob)
      end
    end
  end
end