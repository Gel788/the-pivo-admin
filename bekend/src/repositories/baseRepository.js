class BaseRepository {
  constructor(model) {
    this.model = model;
  }

  async create(data) {
    try {
      const instance = new this.model(data);
      return await instance.save();
    } catch (error) {
      throw error;
    }
  }

  async findById(id) {
    try {
      return await this.model.findById(id);
    } catch (error) {
      throw error;
    }
  }

  async findOne(filter) {
    try {
      return await this.model.findOne(filter);
    } catch (error) {
      throw error;
    }
  }

  async find(filter = {}, options = {}) {
    try {
      const {
        sort = { createdAt: -1 },
        skip = 0,
        limit = 10,
        select,
        populate
      } = options;

      let query = this.model.find(filter);

      if (sort) query = query.sort(sort);
      if (skip) query = query.skip(skip);
      if (limit) query = query.limit(limit);
      if (select) query = query.select(select);
      if (populate) query = query.populate(populate);

      return await query.exec();
    } catch (error) {
      throw error;
    }
  }

  async update(id, data) {
    try {
      return await this.model.findByIdAndUpdate(
        id,
        { $set: data },
        { new: true, runValidators: true }
      );
    } catch (error) {
      throw error;
    }
  }

  async delete(id) {
    try {
      return await this.model.findByIdAndDelete(id);
    } catch (error) {
      throw error;
    }
  }

  async count(filter = {}) {
    try {
      return await this.model.countDocuments(filter);
    } catch (error) {
      throw error;
    }
  }

  async exists(filter) {
    try {
      return await this.model.exists(filter);
    } catch (error) {
      throw error;
    }
  }

  async aggregate(pipeline) {
    try {
      return await this.model.aggregate(pipeline);
    } catch (error) {
      throw error;
    }
  }
}

module.exports = BaseRepository; 