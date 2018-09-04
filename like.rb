class Like < ApplicationRecord
  belongs_to :game, required: false
  
  def self.like_game(user,game_id)
    user_likes = where(game_id: game_id, ip: user, created_at: 5.minutes.ago..Time.now)
    if user_likes.blank?
      game = Game.find_by_id(game_id)
      if not game.nil?
        create(game_id: game_id, ip: user)
        emailBody = "The game " + game.name + " (" + game.year.to_s + "), ID " + game.id.to_s + ", was liked by a user."
        begin
          LikeMailer.like_email(emailBody).deliver_now
        rescue
          p "Problem sending e-mail"
        end
        return true
      else
        p "No game with ID "+game_id.to_s+"."
        return false
      end
    else
      p "Cannot have duplicate likes."
      return false
    end
  end
  
  def self.count(game_id)
    return Like.where(game_id: game_id).count
  end
end
