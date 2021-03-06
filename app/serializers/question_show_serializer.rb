class QuestionShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
