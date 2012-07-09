module Perturbing

  def self.the_hash(object)
    if object.include?(:perturbation)
      object.delete :perturbation
    else
      object.store :perturbation, :perturbed
    end
  end

end
