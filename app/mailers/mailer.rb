class Mailer < ActionMailer::Base
  FROM = ENV.fetch("SUPPORT_EMAIL")

  def comment(arguments = {})
    @author = arguments.fetch(:author)
    @comment = arguments.fetch(:comment)
    @exercise = arguments.fetch(:exercise)
    @recipient = arguments.fetch(:recipient)
    @submitter = arguments.fetch(:submitter)

    mail(
      from: FROM,
      subject: subject_for_comment,
      to: @recipient.email,
    )
  end

  private

  def subject_for_comment
    if @recipient == @submitter
      I18n.t("mailer.comment.subject.self", exercise: @exercise.title)
    else
      I18n.t(
        "mailer.comment.subject.others",
        exercise: @exercise.title,
        username: @submitter.username
      )
    end
  end
end
