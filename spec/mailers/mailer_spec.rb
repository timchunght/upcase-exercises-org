require "spec_helper"

describe Mailer do
  describe "#comment" do
    let(:author) { build_stubbed(:user) }
    let(:comment) { build_stubbed(:comment) }
    let(:exercise) { build_stubbed(:exercise) }

    it "notifies the recipient about a new comment on their solution" do
      submitter_and_recipient = build_stubbed(:user)

      message = build_comment_email(
        recipient: submitter_and_recipient,
        submitter: submitter_and_recipient
      )

      expect(message).to have_subject(
       I18n.t("mailer.comment.subject.self", exercise: exercise.title)
      )
      expect(message).to deliver_to(submitter_and_recipient.email)
      expect(message).to deliver_from(Mailer::FROM)
      expect(message).to have_body_text(author.username)
      expect(message).to have_body_text(comment.text)
      expect(message).to have_body_text(
        exercise_solution_url(exercise, submitter_and_recipient)
      )
    end

    it "notifies the recipient about a new comment on subscribed solution" do
      recipient = build_stubbed(:user)
      submitter = build_stubbed(:user)

      message = build_comment_email(recipient: recipient, submitter: submitter)

      expect(message).to have_subject(
       I18n.t(
         "mailer.comment.subject.others",
         exercise: exercise.title,
         username: submitter.username
       )
      )
    end

    def build_comment_email(
      recipient: build_stubbed(:user),
      submitter: build_stubbed(:user)
    )
      Mailer.comment(
        author: author,
        comment: comment,
        exercise: exercise,
        recipient: recipient,
        submitter: submitter
      )
    end
  end
end
